{
  lib,
  stdenv,
  fetchurl,
  libjack2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "jackmeter";
  version = "0.4";

  src = fetchurl {
    url = "https://www.aelius.com/njh/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1cnvgx3jv0yvxlqy0l9k285zgvazmh5k8m4l7lxckjfm5bn6hm1r";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjack2 ];

  meta = {
    description = "Console jack loudness meter";
    homepage = "https://www.aelius.com/njh/jackmeter/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.linux;
    mainProgram = "jack_meter";
  };
}
