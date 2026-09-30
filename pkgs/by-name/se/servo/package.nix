{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # build deps
  cargo-deny,
  cmake,
  dbus,
  git,
  gnumake,
  llvm,
  llvmPackages,
  m4,
  makeWrapper,
  perl,
  pkg-config,
  python311,
  taplo,
  uv,
  which,
  yasm,

  # runtime deps
  fontconfig,
  freetype,
  gst_all_1,
  harfbuzz,
  libGL,
  libunwind,
  libxkbcommon,
  udev,
  vulkan-loader,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  zlib,

  # tests
  nixosTests,
}:

let
  # match .python-version
  customPython = python311.withPackages (
    ps: with ps; [
      markupsafe
      packaging
      pygments
    ]
  );
  runtimePaths = lib.makeLibraryPath (
    lib.optionals (stdenv.hostPlatform.isLinux) [
      libxcursor
      libxrandr
      libxi
      libxkbcommon
      vulkan-loader
      wayland
      libGL
    ]
  );
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "servo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inhpSzLQExTD5VT7hCzoycYMa2U4oZv8fz7NhZAlP2I=";
    # Breaks reproducibility depending on whether the picked commit
    # has other ref-names or not, which may change over time, i.e. with
    # "ref-names: HEAD -> main" as long this commit is the branch HEAD
    # and "ref-names:" when it is not anymore.
    postFetch = ''
      rm $out/tests/wpt/tests/tools/third_party/attrs/.git_archival.txt
    '';
  };

  cargoHash = "sha256-hjea0ze+GO3i+x1HZxSpWfXc57kvVVjmTWl2ytQYxco=";

  postPatch = ''
    # The mozjs crates all use cbindgen with `cargo metadata` invocations,
    # which looks up the nearest cargo config.
    # In our case, that's $cargoDepsCopy/.cargo/config.toml, which is the
    # template of the config cargo-setup-hook creates in the build directory.
    # The easiest workaround is to copy the final config back into $cargoDepsCopy,
    # so `cargo metadata` invoked inside the mozjs crates finds the correct vendor path.
    cp .cargo/config.toml $cargoDepsCopy/.cargo/config.toml
    # We also need to make sure that `cargo metadata` knows what versions each of the
    # mozjs crates' dependencies resolve to in our dependency cache, which can be achieved
    # by copying our lockfile into the mozjs crate directories.
    for mozjs_dir in $cargoDepsCopy/*/mozjs_*/; do
      cp Cargo.lock $mozjs_dir
    done
  '';

  # set `HOME` to a temp dir for write access
  # Fix invalid option errors during linking (https://github.com/mozilla/nixpkgs-mozilla/commit/c72ff151a3e25f14182569679ed4cd22ef352328)
  preConfigure = ''
    export HOME=$TMPDIR
    unset AS
  '';

  nativeBuildInputs = [
    cargo-deny
    cmake
    customPython
    dbus
    git
    gnumake
    llvm
    llvmPackages.libstdcxxClang
    m4
    makeWrapper
    perl
    pkg-config
    rustPlatform.bindgenHook
    taplo
    uv
    which
    yasm
  ];

  env.UV_PYTHON = customPython.interpreter;

  buildInputs = [
    fontconfig
    freetype
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    harfbuzz
    libunwind
    libGL
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libx11
    libxcb
    udev
    vulkan-loader
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # mozjs-sys fails with:
      #  cc1plus: error: '-Wformat-security' ignored without '-Wformat'
      "-Wno-error=format-security"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1"
    ]
  );

  # copy resources into `$out` to be used during runtime
  # link runtime libraries
  postFixup = ''
    mkdir -p $out/resources
    cp -r ./resources $out/

    wrapProgram $out/bin/servoshell \
      --prefix LD_LIBRARY_PATH : ${runtimePaths}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) servo; };
  };

  meta = {
    # undefined libmozjs_sys symbols during linking
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/servo/servo/releases/tag/${finalAttrs.src.tag}";
    description = "Embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "servoshell";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
