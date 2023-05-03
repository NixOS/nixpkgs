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
, stdenv
, gtk3
, darwin
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.6.63";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    sha256 = "sha256-ynxGpx8LLcd4/n9hz/bbhpZUxqX1sPS7LFYPZ22hTxo=";
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
    libX11
    libXcursor
    libXi
    libXrandr
    libGL
    gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/oculante --add-rpath ${lib.makeLibraryPath [ libGL ]}
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
