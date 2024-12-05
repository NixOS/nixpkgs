{ stdenv
, lib
, fetchgit
, avahi
, gmp
, buildPackages
, autoreconfHook
, pkg-config
, texinfo
, guile
}:

stdenv.mkDerivation rec {
  pname = "guile-avahi";
  version = "0.4.1";

  src = fetchgit {
    url = "git://git.sv.gnu.org/guile-avahi.git";
    rev = "v${version}";
    hash = "sha256-Yr+OiqaGv6DgsjxSoc4sAjy4OO/D+Q50vdSTPEeIrV8=";
  };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook guile pkg-config texinfo ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ avahi gmp ];

  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-unused-function";

  meta = with lib; {
    description = "Bindings to Avahi for GNU Guile";
    homepage = "https://www.nongnu.org/guile-avahi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}

