{ fetchurl, lib, stdenv, gettext, libmpcdec, libao }:

let version = "0.2.4"; in
stdenv.mkDerivation rec {
  pname = "mpc123";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mpc123/version%20${version}/${pname}-${version}.tar.gz";
    sha256 = "0sf4pns0245009z6mbxpx7kqy4kwl69bc95wz9v23wgappsvxgy1";
  };

  patches = [ ./use-gcc.patch ];

  buildInputs = [ gettext libmpcdec libao ];

  installPhase =
    # XXX: Should install locales too (though there's only 1 available).
    '' mkdir -p "$out/bin"
       cp -v mpc123 "$out/bin"
    '';

  meta = {
    homepage = "http://mpc123.sourceforge.net/";

    description = "A Musepack (.mpc) audio player";

    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux; # arbitrary choice
  };
}
