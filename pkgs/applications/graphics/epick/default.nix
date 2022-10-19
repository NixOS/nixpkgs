{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, expat
, fontconfig
, freetype
, libGL
, xorg
, darwin
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "epick";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = version;
    sha256 = "sha256-k0WQu1n1sAHVor58jr060vD5/2rDrt1k5zzJlrK9WrU=";
  };

  cargoSha256 = "sha256-OQZPOiMTpoWabxHa3TJG8L3zq8WxMeFttw8xggSXsMA=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    expat
    fontconfig
    freetype
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/epick --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  meta = with lib; {
    description = "Simple color picker that lets the user create harmonic palettes with ease";
    homepage = "https://github.com/vv9k/epick";
    changelog = "https://github.com/vv9k/epick/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
