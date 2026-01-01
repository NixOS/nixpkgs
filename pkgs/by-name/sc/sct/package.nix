{
  lib,
  stdenv,
  fetchzip,
  libX11,
  libXrandr,
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
    libX11
    libXrandr
    xorgproto
  ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.umaxx.net/";
    description = "Minimal utility to set display colour temperature";
    maintainers = with lib.maintainers; [
      raskin
      somasis
    ];
    license = lib.licenses.isc;
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd;
=======
  meta = with lib; {
    homepage = "https://www.umaxx.net/";
    description = "Minimal utility to set display colour temperature";
    maintainers = with maintainers; [
      raskin
      somasis
    ];
    license = licenses.isc;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
