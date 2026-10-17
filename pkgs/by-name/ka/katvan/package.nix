{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  cargo,
  wrapGAppsHook3,

  # buildInputs
  qt6,
  libarchive,
  corrosion,
  hunspell,

  # checkInputs
  gtest,

  # passthru
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "katvan";
  version = "0.14.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "katvan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bbVwnvJgirdXE8zvAH5B7txxMpv+Wgvj9EIThR2s1AA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-xgujm9umsl6tZ/c7enXKZNcAUnV7UsMS3L+O/kEERdk=";
  };

  # The CMakeLists files used by upstream issue a `cargo install` command to
  # install a rust tool (cxxbridge-cmd) that is supposed to be included in the Cargo.toml's and
  # `Cargo.lock` files of upstream. Setting CARGO_HOME like that helps `cargo
  # install` find the dependencies we prefetched. See also:
  # https://github.com/GothenburgBitFactory/taskwarrior/issues/3705
  postUnpack = ''
    export CARGO_HOME=$PWD/.cargo
  '';

  cargoRoot = "typstdriver/rust";

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qttools
    rustPlatform.cargoSetupHook
    rustc
    cargo
    (python3.withPackages (ps: [
      ps.mistletoe
    ]))
    wrapGAppsHook3 # needed for file dialogs
  ];

  buildInputs = [
    qt6.qtbase
    libarchive
    corrosion
    hunspell
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    # Don't set this to an absolute path, as it breaks upstream rpath settings
    # for the final executable, see: https://github.com/IgKh/katvan/issues/46
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "bare-bones editor for Typst files, with a bias for Right-to-Left editing";
    homepage = "https://github.com/IgKh/katvan";
    changelog = "https://github.com/IgKh/katvan/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "katvan";
    platforms = lib.platforms.all;
  };
})
