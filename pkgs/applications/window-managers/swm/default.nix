{ stdenv, fetchgit, libxcb, wmutils-core }:

let
  version = "2015-07-07";
in
  stdenv.mkDerivation rec {
    name = "swm-${version}";

    src = fetchgit {
      url = "https://github.com/dcat/swm";
      rev = "151f81ea9fb1949905f405c5c372f25e9aede6fc";
      sha256 = "04x8397vld038znaznv24ygng3rc8mj8l5mg286fv35fdvzswaz0";
    };

    buildInputs = [ libxcb ];

    prePatch = ''
      sed -i "s@/usr/local@$out@" config.mk
    '';

    buildPhase = ''
      make PREFIX=$out
    '';

    installPhase = ''
      make PREFIX=$out install
    '';

    meta = {
      description = "Simple Window Manager";
      homepage = http://github.com/dcat/swm;
      maintainers = [ stdenv.lib.maintainers.afadhyatma ];
      license = stdenv.lib.licenses.bsd2;
      platforms = stdenv.lib.platforms.linux;
    };
  }
