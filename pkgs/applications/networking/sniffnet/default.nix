{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpcap
, stdenv
, alsa-lib
, expat
, fontconfig
, vulkan-loader
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffnet";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "gyulyvgc";
    repo = "sniffnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-QEMd/vOi0DFCq7AJHhii7rnBAHS89XP3/b2UIewAgLc=";
  };

  cargoHash = "sha256-VcmiM7prK5l8Ow8K9TGUR2xfx9648IoU6i40hOGAqGQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    expat
    fontconfig
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    rustPlatform.bindgenHook
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/sniffnet \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "Cross-platform application to monitor your network traffic with ease";
    homepage = "https://github.com/gyulyvgc/sniffnet";
    changelog = "https://github.com/gyulyvgc/sniffnet/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
