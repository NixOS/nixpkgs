{ stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gperf,
  libXcursor,
  libXxf86vm,
  libXi,
  xclip }:

with rustPlatform;

buildRustPackage rec {
  name = "alacritty-unstable-2017-07-08";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "94849c4f2a19bd49337f5cf090f94ac6a940c414";
    sha256 = "0cawrq0787pcfifn5awccq29a1ag85wfbmx1ccz7m33prk3ry9jp";
  };

  depsSha256 = "0lb83aan6lgdsdcrd6zdrxhz5bi96cw4ygqqlpm43w42chwzz0xj";

  buildInputs = [
    cmake
    makeWrapper
    freetype
    fontconfig
    xclip
    pkgconfig
    expat
    libX11
    libXcursor
    libXxf86vm
    libXi
  ];

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
    wrapProgram $out/bin/alacritty --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath buildInputs}"
  '';


  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.all;
  };
}
