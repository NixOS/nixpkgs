{ buildPackages, lib, stdenv, fetchurl, gettext, libgpg-error }:

stdenv.mkDerivation rec {
  pname = "libksba";
  version = "1.6.7";

  src = fetchurl {
    url = "mirror://gnupg/libksba/libksba-${version}.tar.bz2";
    hash = "sha256-z3JRC467TrZpPu92V0nYNnegPHkpGjEQQKW/15uqt2M=";
  };

  outputs = [ "out" "dev" "info" ];

  buildInputs = [ gettext ];
  propagatedBuildInputs = [ libgpg-error ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [ "--with-libgpg-error-prefix=${libgpg-error.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $out/bin/*-config $dev/bin/
    rmdir --ignore-fail-on-non-empty $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.gnupg.org";
    description = "CMS and X.509 access library";
    mainProgram = "ksba-config";
    platforms = platforms.all;
    maintainers = [ ];
    license = licenses.lgpl3;
  };
}
