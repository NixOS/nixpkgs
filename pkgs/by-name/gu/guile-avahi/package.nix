{ stdenv
, lib
, fetchgit
, avahi
, gmp
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

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ avahi gmp ];

  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = with lib; {
    description = "Bindings to Avahi for GNU Guile";
    homepage = "https://www.nongnu.org/guile-avahi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}

