{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, which
, texi2html
, enableX11 ? true
, libX11, libXext, libXv, libpng
}:

stdenv.mkDerivation rec {
  pname = "qemacs";
  version = "5.4.1c";

  src = fetchFromGitHub {
    owner = "qemacs";
    repo = "qemacs";
    rev = "216b3ff8b77ff138aec22045522d5601b7390e58";
    hash = "sha256-ngVaZZdr/Ym9YswLqzUtDytC0K7L9mKgORopLghGH3k=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace \
      '$(INSTALL) -m 755 -s' \
      '$(INSTALL) -m 755 -s --strip-program=${stdenv.cc.targetPrefix}strip'
  '';

  nativeBuildInputs = [ which texi2html ];
  buildInputs = lib.optionals enableX11 [ libpng libX11 libXext libXv ];

  enableParallelBuilding = true;

  configureFlags = [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
  ] ++ lib.optionals (!enableX11) [
    "--disable-x11"
  ];

  makeFlags = [
    # is actually used as BUILD_CC
    "HOST_CC=${buildPackages.stdenv.cc}/bin/cc"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/man
  '';

  meta = with lib; {
    homepage = "https://bellard.org/qemacs/";
    description = "Very small but powerful UNIX editor";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ iblech ];
  };
}
