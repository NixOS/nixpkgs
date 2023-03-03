{ lib, stdenv, fetchurl, alsa-lib, expat, glib, libjack2, libXext, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkg-config, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.20";
  pname = "drumgizmo";

  src = fetchurl {
    url = "https://www.drumgizmo.org/releases/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-AF8gQLiB29j963uI84TyNHIC0qwEWOCqmZIUWGq8V2o=";
  };

  configureFlags = [ "--enable-lv2" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib expat glib libjack2 libXext libX11 libpng libpthreadstubs
    libsmf libsndfile lv2 zita-resampler
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "An LV2 sample based drum plugin";
    homepage = "https://www.drumgizmo.org";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}
