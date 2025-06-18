{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "liblogging";
  version = "1.0.6";

  src = fetchurl {
    url = "http://download.rsyslog.com/liblogging/liblogging-${version}.tar.gz";
    sha256 = "14xz00mq07qmcgprlj5b2r21ljgpa4sbwmpr6jm2wrf8wms6331k";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals withSystemd [ systemd ];

  configureFlags = [
    "--enable-rfc3195"
    "--enable-stdlog"
    (if withSystemd then "--enable-journal" else "--disable-journal")
    "--enable-man-pages"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int -Wno-error=implicit-function-declaration";

  meta = with lib; {
    homepage = "http://www.liblogging.org/";
    description = "Lightweight signal-safe logging library";
    mainProgram = "stdlogctl";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
