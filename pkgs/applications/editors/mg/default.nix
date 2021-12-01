{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, buildPackages }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "6.9";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "mg";
    rev = "mg-${version}";
    sha256 = "1w49yb9v1657rv1w5w7rc9ih1d2vzv6ym3mzhf2wgmh04pdm6hid";
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
