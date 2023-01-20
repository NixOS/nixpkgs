{ lib
, stdenv
, fetchurl
, buildPackages
, enableX11 ? true
, libX11, libXext, libXv, libpng
}:

stdenv.mkDerivation rec {
  pname = "qemacs";
  version = "0.3.3";

  src = fetchurl {
    url = "https://bellard.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "156z4wpj49i6j388yjird5qvrph7hz0grb4r44l4jf3q8imadyrg";
  };

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace Makefile --replace \
      './fbftoqe $(FONTS) > $@' \
      '${buildPackages.qemacs}/bin/fbftoqe $(FONTS) > $@'
  '' + ''
    substituteInPlace Makefile --replace \
      '$(HOST_CC) $(LDFLAGS) -o $@ html2png.o $(OBJS)' \
      '$(CC) $(LDFLAGS) -o $@ html2png.o $(OBJS)'
    substituteInPlace Makefile --replace \
      'install -m 755 -s' \
      "install -m 755 -s --strip-program=''${STRIP}"
  '';

  buildInputs = lib.optionals enableX11 [ libpng libX11 libXext libXv ];

  configureFlags = [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--extra-cflags=-Ilibqhtml"
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

  postInstall = ''
    install -Dt $out/bin fbftoqe
  '';

  meta = with lib; {
    homepage = "https://bellard.org/qemacs/";
    description = "Very small but powerful UNIX editor";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ iblech ];
  };
}
