{
  lib,
  stdenv,
  fetchzip,
  libx11,
  libxrandr,
  xorgproto,
}:

stdenv.mkDerivation {
  pname = "sct";
  version = "0.5";

  src = fetchzip {
    url = "https://www.umaxx.net/dl/sct-0.5.tar.gz";
    sha256 = "sha256-nyYcdnCq8KcSUpc0HPCGzJI6NNrrTJLAHqPawfwPR/Q=";
  };

  buildInputs = [
    libx11
    libxrandr
    xorgproto
  ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://www.umaxx.net/";
    description = "Minimal utility to set display colour temperature";
    maintainers = with lib.maintainers; [
      raskin
      somasis
    ];
    license = lib.licenses.isc;
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd;
  };
}
