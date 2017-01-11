{ stdenv, fetchFromGitHub, rustPlatform, cmake, gcc, pkgconfig,
  freetype, expat, gperf, libX11, libXcursor, libXxf86vm, libXi }:

with rustPlatform;

buildRustPackage rec {
  name = "alacritty-unstable-${version}";
  version = "2017-01-07";

  depsSha256 = "138bfnrg3j49vl6j2daf1jyyng5r6d088qhsqikhyyqzjx1ih0v2";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "f4b10a1dbb991861a84c5085a0ee4384d2377448";
    sha256 = "044l5s1w2g5krngr1v4lfxv7smh6wzy9zrabnihnpf1bsg6q73nb";
  };

  nativeBuildInputs = [
    cmake gcc pkgconfig freetype expat gperf
    libX11 libXcursor libXxf86vm libXi
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GPU accelerated terminal emulator";
    longDescription = ''
      Alacritty is focused on simplicity and performance.
      The performance goal means it should be faster than any
      other terminal emulator available. The simplicity goal
      means that it doesn't have many features like tabs or
      scroll back as in other terminals. Instead, it is
      expected that users of Alacritty make use of a terminal
      multiplexer such as tmux.
    '';
    homepage = https://github.com/jwilm/alacritty;
    license = licenses.asl20;
    maintainer = [ maintainers.exi ];
  };
}
