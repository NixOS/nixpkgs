{ stdenv, fetchFromGitHub, coreutils, nixosTests }:

stdenv.mkDerivation rec {
  pname = "3proxy";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "z3APA3A";
    repo = pname;
    rev = version;
    sha256 = "0vx6cf3jdlg1h8755ryvfzqh9ld3r5i62ygw9vc6clzl5k1jkapm";
  };

  preConfigure = ''
    ln -s Makefile.Linux Makefile
  '';

  installPhase = ''
    mkdir -p $out/libexec
    make INSTALL=${coreutils}/bin/install CHROOTDIR=$out prefix=$out man_prefix=$out install-bin install-man
  '';

  passthru.tests._3proxy = nixosTests._3proxy;

  meta = with stdenv.lib; {
    description = "Tiny free proxy server";
    homepage = "https://github.com/z3APA3A/3proxy";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.misuzu ];
  };
}
