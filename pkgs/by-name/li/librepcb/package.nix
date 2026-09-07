{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  opencascade-occt,
  libGLU,
  cmake,
  rustPlatform,
  cargo,
  rustc,
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "librepcb";
    repo = "librepcb";
    rev = version;
    hash = "sha256-UcX4r2TxinL2S3tPIiYRsPpYmKzdAx3Al0irkbXf5/g=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.qtsvg
    qt6.wrapQtAppsHook
    opencascade-occt
    libGLU
    cargo
    rustc
  ];
  buildInputs = [ qt6.qtbase ];

  cargoDeps1 = rustPlatform.fetchCargoVendor {
    inherit src;
    cargoRoot = "libs/librepcb/rust-core";
    hash = "sha256-1wHk8ynP3VnkypwY/C7nikfMSF0qU0L+CbBKoVxjlEc=";
  };

  cargoDeps2 = rustPlatform.fetchCargoVendor {
    inherit src;
    cargoRoot = "libs/slint";
    hash = "sha256-UX/7a0hzFBmPZKufcDKcICrXEM+rKcvqEq2pg1riBxo=";
  };

  postPatch = ''
    # Set up cargo config for the first Rust library
    mkdir -p libs/librepcb/rust-core/.cargo
    cat > libs/librepcb/rust-core/.cargo/config.toml <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    [source.vendored-sources]
    directory = "${cargoDeps1}/source-registry-0"
    EOF

    # Set up cargo config for the second Rust library
    mkdir -p libs/slint/.cargo
    cat > libs/slint/.cargo/config.toml <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"
    [source.vendored-sources]
    directory = "${cargoDeps2}/source-registry-0"
    EOF
  '';

  meta = {
    description = "Free EDA software to develop printed circuit boards";
    homepage = "https://librepcb.org/";
    maintainers = with lib.maintainers; [
      luz
      thoughtpolice
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
