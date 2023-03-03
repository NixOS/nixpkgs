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
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.6.41";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    sha256 = "sha256-2pXfdR5KUD6IUasxyUptxLSLDcvJtwJwOmhHD3I7op8=";
  };

  cargoHash = "sha256-F/NKTsDRfoueVrwlq/RkBR6wNn79NiuT2InAR+XPbqw=";

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
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
    maintainers = with maintainers; [ dit7ya ];
  };
}
