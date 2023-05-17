{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, makeWrapper
, AppKit
, CoreFoundation
, CoreGraphics
, CoreVideo
, Foundation
, Metal
, QuartzCore
, xorg
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "binocle";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L4l8Gl7Ok/TWqHjNujPx8Qk3UWebs0SgOQNyBNtpnZo=";
  };

  cargoHash = "sha256-9d0MNQ7jEJKpGbjVtl1XBoOBEVNKDgFouSMrcZ7tXNU=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit CoreFoundation CoreGraphics CoreVideo Foundation Metal QuartzCore
  ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    wrapProgram $out/bin/binocle \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath (with xorg; [ libX11 libXcursor libXi libXrandr ] ++ [ vulkan-loader ])}
  '';

  meta = with lib; {
    description = "Graphical tool to visualize binary data";
    homepage = "https://github.com/sharkdp/binocle";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
