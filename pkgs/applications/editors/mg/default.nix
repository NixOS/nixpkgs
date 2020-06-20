{ stdenv, fetchFromGitHub, pkgconfig, ncurses, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "6.7";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "mg";
    rev = "mg-6.7";
    sha256 = "15adwibq6xrfxbrxzk765g9250iyfn4wbcxd7kcsabiwn6apm0ai";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${buildPackages.pkgconfig}/bin/${buildPackages.pkgconfig.targetPrefix}pkg-config" ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';
  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://man.openbsd.org/OpenBSD-current/man1/mg.1";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
