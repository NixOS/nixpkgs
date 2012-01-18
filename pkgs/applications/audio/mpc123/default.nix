{ fetchurl, stdenv, gettext, libmpcdec, libao }:

let version = "0.2.4"; in
stdenv.mkDerivation rec {
  name = "mpc123-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mpc123/version%20${version}/${name}.tar.gz";
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
    homepage = http://mpc123.sourceforge.net/;

    description = "mpc123, a Musepack (.mpc) audio player";

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu; # arbitrary choice
  };
}
