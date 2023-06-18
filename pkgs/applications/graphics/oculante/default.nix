{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, fontconfig
, nasm
, libX11
, libXcursor
, libXrandr
, libXi
, libGL
, libxkbcommon
, wayland
, stdenv
, gtk3
, darwin
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.6.65";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    hash = "sha256-99wA8BELw/FsiwGtWmbZedANjHamK1IHnl4wHwPAGIE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    perl
  ];

  checkFlagsArray = [ "--skip=tests::net" ]; # requires network access

  buildInputs = [
    openssl
    fontconfig
  ] ++ lib.optionals stdenv.isLinux [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    gtk3

    libxkbcommon
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
  ];

  checkFlags = [
    "--skip=bench"
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/oculante --add-rpath ${lib.makeLibraryPath [ libxkbcommon libX11 ]}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A minimalistic crossplatform image viewer written in Rust";
    homepage = "https://github.com/woelper/oculante";
    changelog = "https://github.com/woelper/oculante/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
