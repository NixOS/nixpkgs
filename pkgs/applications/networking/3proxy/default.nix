{ stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  pname = "3proxy";
  version = "0.8.13";
  src = fetchFromGitHub {
    owner = "z3APA3A";
    repo = pname;
    rev = version;
    sha256 = "1k5rqldiyakhwhplazlhswkgy3psdkpxhn85605ncwaqx49qy8vk";
  };
  makeFlags = [
    "INSTALL=${coreutils}/bin/install"
    "prefix=$(out)"
  ];
  preConfigure = ''
    ln -s Makefile.Linux Makefile
  '';
  meta = with stdenv.lib; {
    description = "Tiny free proxy server";
    homepage = "https://github.com/z3APA3A/3proxy";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.misuzu ];
  };
}
