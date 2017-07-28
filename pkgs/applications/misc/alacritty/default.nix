{ stdenv, fetchFromGitHub, rustPlatform, cmake, gcc, pkgconfig,
  freetype, expat, gperf, libX11, libXcursor, libXxf86vm, libXi }:

with rustPlatform;

buildRustPackage rec {
  name = "alacritty-unstable-2017-07-25";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "49c73f6d55e5a681a0e0f836cd3e9fe6af30788f";
    sha256 = "0h5hrb2g0fpc6xn94hmvxjj21cqbj4vgqkznvd64jl84qbyh1xjl";
  };

  depsSha256 = "1pbb0swgpsbd6x3avxz6fv3q31dg801li47jibz721a4n9c0rssx";

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
