{
  stdenv,
  lib,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  coreutils,
  bash,
  direnv,
  git,
  pkg-config,
  openssl,
  cmake,
  cacert,
  tzdata,
  usage,
  testers,
  runCommand,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.9.15";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-atiEHEDKlAfqGdJa46v0z2aTt03CKLHFaEuJ5QKyD0Y=";
  };

  cargoHash = "sha256-i96rOfxrL95T6RHWbFlKhRfzicctp3bbQK7LewT7wIg=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/generate/git_pre_commit.rs

    # env + direnv are still invoked by name from the top-level crate; pin them.
    # (The git and bash spawns moved into the mise-util crate in 2026.9.x and now
    # resolve via PATH — they are provided at runtime by the wrapper below.)
    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${lib.getExe' coreutils "env"}"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${lib.getExe direnv}"'
  '';

  nativeCheckInputs = [
    bash
    cacert
    cmake
    # gix spawns git-upload-pack by name in file:// clone tests.
    git
    rustPlatform.bindgenHook
  ];

  env = {
    # disable warnings as errors for aws-lc-sys in checkPhase
    NIX_CFLAGS_COMPILE = "-Wno-error";
    # tera date helper tests look up timezone data via TZDIR.
    TZDIR = "${tzdata}/share/zoneinfo";
  };

  checkFlags = [
    # last_modified will always be different in nix
    "--skip=tera::tests::test_last_modified"
    # brew cask tests refuse to operate through the sandbox's "untrusted" root
    # directory (and are macOS-oriented anyway); we don't test brew here.
    "--skip=system::packages::brew::cask::tests::"
    # performs a privileged filesystem operation the build sandbox forbids (EPERM).
    "--skip=system_install::tests::archive_boundary"
    # shells out to the Swift toolchain, which is unavailable in the sandbox.
    "--skip=backend::spm::tests::test_inline_install_command_uses_install_environment"
    # runs the built mise binary to write a node-gyp trampoline, which the build
    # sandbox blocks (EACCES).
    "--skip=mise_binary_services_aube_node_gyp_bootstrap_trampoline"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # exercise the macOS `defaults` binary and per-user containers, which the
    # darwin sandbox refuses to exec / write to.
    "--skip=system::defaults::tests::"
  ];

  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

  # HTTP tests use mock servers that bind to localhost. Without this, darwin builds fail.
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise

    mkdir -p $out/lib/mise
    touch $out/lib/mise/.disable-self-update

    # mise shells out to git (plugin/repo operations) and bash (env_diff sources
    # scripts through it). Since 2026.9.x these resolve via PATH from the mise-util
    # crate, so ensure nixpkgs' git and bash are on mise's PATH.
    wrapProgram $out/bin/mise \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          bash
        ]
      }
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        # Ignore subcrate releases (fox, aqua-registry)
        "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
    tests = {
      version = (testers.testVersion { package = finalAttrs.finalPackage; }).overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ cacert ];
      });
      usageCompat =
        # should not crash
        runCommand "mise-usage-compatibility"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              usage
              jq
            ];
          }
          ''
            export HOME=$(mktemp -d)

            for shl in bash fish zsh; do
              echo "testing $shl"
              usage complete-word --shell $shl --file <(mise usage)
            done

            touch $out
          '';
    };
  };

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "Front-end to your dev env";
    changelog = "https://github.com/jdx/mise/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      konradmalik
      Br1ght0ne
    ];
    mainProgram = "mise";
  };
})
