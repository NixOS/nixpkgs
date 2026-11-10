{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  zig_0_16,
  cctools,
  installAgentSkills,
  bash,
  coreutils,
  curl,
  gawk,
  git,
  gnused,
  gnutar,
  gzip,
  jq,
  libarchive,
  openssl,
  python3,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr-core";
  version = "0.1.18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr-core";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-MSq0Tzlv0/aOQvuXkeuVuGx3vpUauxI1YAeLpKy7WG4=";
  };

  cargoHash = "sha256-d3dTX5qvikpkIABz0ecDjPu1pA0LsSmPu5j4Oum6R3c=";

  # zig.fetchDeps fails in the Darwin sandbox with CertificateBundleLoadFailure:
  # Zig reads its root certificates from the system keychains, which the
  # sandbox hides. The output is the same on every platform, so Darwin builds
  # take it from the cache; without one, build it with `--option sandbox false`.
  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/ghostty";
    fetchAll = true;
    hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
  };

  nativeBuildInputs = [
    installAgentSkills
  ]
  # Ghostty combines its static archives with Apple's `libtool -static`.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  env = {
    ZIG = lib.getExe zig_0_16;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    # hc tells builds apart by their GNU build id, so a byte-identical copy of
    # the binary counts as the same build. Without one it falls back to the
    # file's identity.
    NIX_SET_BUILD_ID = "1";
    # The linker hashes the debug sections into the build id, and those hold
    # Zig cache paths that change from build to build. Dropping them at link
    # time keeps the build id reproducible; stdenv strips them anyway.
    NIX_LDFLAGS = "--strip-debug";
  };

  postPatch =
    let
      # What the tests expect on the other machine.
      remoteBin = lib.makeBinPath [
        bash
        coreutils
        gawk
        python3
      ];
      # What install.sh calls.
      installerBin = lib.makeBinPath [
        bash
        coreutils
        curl
        gnused
        gnutar
        gzip
      ];
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Bundled Zig runtimes cause overlapping unwind frames when linked with
      # Rust. Darwin keeps them: Ghostty's libsystem_override.sh extracts
      # compiler_rt.o from the archive.
      substituteInPlace vendor/ghostty/src/build/GhosttyLibVt.zig \
        --replace-fail 'lib.bundle_compiler_rt = true;' 'lib.bundle_compiler_rt = false;' \
        --replace-fail 'lib.bundle_ubsan_rt = true;' 'lib.bundle_ubsan_rt = false;'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Ghostty's build calls these by absolute path, which the sandbox lacks.
      substituteInPlace vendor/ghostty/pkg/apple-sdk/native_link.zig \
        --replace-fail '"/usr/bin/xcrun"' '"xcrun"'
      substituteInPlace vendor/ghostty/src/build/GhosttyLibVt.zig \
        --replace-fail '"/bin/ln"' '"ln"'
      substituteInPlace vendor/ghostty/src/build/LibtoolStep.zig \
        --replace-fail '/bin/cp ' 'cp ' \
        --replace-fail '/usr/bin/ranlib ' 'ranlib '
    ''
    + ''
      # hc downloads, checks and unpacks release builds for machines it adds.
      # bsdtar unpacks gzip itself; GNU tar would look up gzip on PATH. ssh
      # and the systemd tools stay on PATH: they have to match the host.
      substituteInPlace crates/herdr-core/src/releases.rs \
        --replace-fail 'Command::new("curl")' 'Command::new("${lib.getExe curl}")' \
        --replace-fail 'run("sha256sum"' 'run("${lib.getExe' coreutils "sha256sum"}"' \
        --replace-fail '_ => "tar".into()' '_ => "${lib.getExe' libarchive "bsdtar"}".into()'

      # To set up a machine with the same OS and CPU, hc copies its own
      # binary there. This binary loads its libraries from /nix/store and
      # calls the tools pinned above, so the copy fails on any machine that
      # lacks those exact store paths. Every machine gets this version's
      # statically linked release build instead, as other CPUs already do.
      substituteInPlace crates/herdr-core/src/machines.rs \
        --replace-fail 'let bin = if there == here && (' 'let bin = if false && ('

      # The tests use /var/tmp, which the sandbox lacks.
      for f in crates/herdr-core/{src/platform/systemd.rs,src/remote/tests.rs,src/runtime/tests.rs,src/viewers/tests.rs,tests/common/mod.rs,tests/m1.rs,tests/macos_distribution.rs}; do
        substituteInPlace "$f" --replace-fail /var/tmp "$TMPDIR"
      done

      # The fake ssh in the tests gives the other machine PATH=/usr/bin:/bin,
      # which the sandbox lacks.
      substituteInPlace crates/herdr-core/tests/common/mod.rs \
        --replace-fail ':/usr/bin:/bin ' ':${remoteBin} ' \
        --replace-fail 'PATH=/usr/bin:/bin ' 'PATH=${remoteBin} '

      # The installer tests run install.sh with /usr/bin:/bin as PATH to hide
      # any installed hc; the sandbox lacks both directories.
      substituteInPlace crates/herdr-core/tests/distribution.rs \
        --replace-fail '.env("PATH", "/usr/bin:/bin")' '.env("PATH", "${installerBin}")' \
        --replace-fail '"{}:/usr/bin:/bin"' '"{}:${installerBin}"'

      # tests/distribution.rs runs this python3 script.
      patchShebangs scripts/manifest
    '';

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeCheckInputs = [
    # One installer test runs install.sh with the build's PATH.
    curl
    git
    python3
    # tests/macos_distribution.rs runs the macOS release scripts against
    # stub tools; the scripts also call these.
    jq
    openssl
  ];

  # The Darwin sandbox blocks what several tests need, such as localhost
  # networking and notifyd. Upstream's macOS CI runs without a sandbox.
  doCheck = !stdenv.hostPlatform.isDarwin;

  # postPatch makes hc download a release build for every machine it sets up,
  # and these two tests try to set one up. The sandbox has no network.
  checkFlags = [
    "--skip=a_box_without_hc_gets_this_one_when_you_say_yes"
    "--skip=a_machine_reached_through_any_command_works_like_one_over_ssh"
  ];

  # Upstream CI's settings for slow runners: a test binary aborts after 30 s
  # otherwise, and one test checks a 50 ms timing a loaded builder can miss.
  preCheck = ''
    export HC_TEST_WATCHDOG_S=120
    export HC_TEST_SLOW_RUNNER=1
  '';

  # The skill hook would install every SKILL.md in the tree: src/SKILL.md is
  # the manual compiled into `hc --skill`, and vendor/ghostty carries its own.
  # Only the stub under skills/ is meant to be installed.
  dontInstallAgentSkills = true;

  postInstall = ''
    ln -s herdr-core $out/bin/hc
    installSkill skills/herdr-core
    install -Dm644 LICENSE crates/herdr-core/THIRD-PARTY-NOTICES -t $out/share/licenses/herdr-core
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Persistent terminal and coding agent backend for Herdr";
    homepage = "https://github.com/herdrdev/herdr-core";
    # The binary also includes libghostty-vt and its dependencies under other
    # free licenses; see share/licenses/herdr-core/THIRD-PARTY-NOTICES.
    license = with lib.licenses; [
      asl20
      mit # libghostty-vt
    ];
    maintainers = with lib.maintainers; [
      iamppborah
      munksgaard
      tophcodes
    ];
    mainProgram = "hc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
