{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libpcap
, stdenv
, fontconfig
, libGL
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffnet";
  version = "1.0.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-8K774j04BOEuJjnFYjaSctPwBrKYYKqjFS2+PyxJ2FM=";
  };

  cargoSha256 = "sha256-096i4wDdoJCICd0L2QNY+7cKHQnijK22zj4XaQNuko8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
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
