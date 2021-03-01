{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "mg";
    rev = "mg-6.8.1";
    sha256 = "0fyqyi5sag13jx8bc22bvkgybddvsr0wdili9ikxnpnqg2w84fx7";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config" ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://man.openbsd.org/OpenBSD-current/man1/mg.1";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
