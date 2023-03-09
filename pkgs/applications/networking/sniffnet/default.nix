{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpcap
, stdenv
, alsa-lib
, expat
, fontconfig
, libGL
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffnet";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "gyulyvgc";
    repo = "sniffnet";
    rev = "v${version}";
    hash = "sha256-o971F3JxZUfTCaLRPYxCsU5UZ2VcvZftVEl/sZAQwpA=";
  };

  cargoHash = "sha256-Otn5FvZZkzO0MHiopjU2/+redyusituDQb7DT5bdbPE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    expat
    fontconfig
    libGL
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
      --add-rpath ${lib.makeLibraryPath [ libGL xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "Cross-platform application to monitor your network traffic with ease";
    homepage = "https://github.com/gyulyvgc/sniffnet";
    changelog = "https://github.com/gyulyvgc/sniffnet/blob/main/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
