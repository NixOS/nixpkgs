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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b0hf2aq34kxxj0la0yar5sp44k6mqcbyailp6j6q0mksf1l74bc";
  };

  cargoSha256 = "sha256-CZWAHWZYaL54Rl6Jrp8B6w6HK+2fIKQle2x4mGHv2/o=";

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
