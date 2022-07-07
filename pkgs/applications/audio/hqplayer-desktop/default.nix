{ mkDerivation
, alsa-lib
, autoPatchelfHook
, fetchurl
, flac
, gcc11
, lib
, libmicrohttpd
, llvmPackages_10
, qtcharts
, qtdeclarative
, qtquickcontrols2
, qtwebengine
, qtwebview
, rpmextract
, wavpack
}:

mkDerivation rec {
  pname = "hqplayer-desktop";
  version = "4.13.1-38";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/hqplayer/fc34/hqplayer4desktop-${version}.fc34.x86_64.rpm";
    sha256 = "sha256-DEZWEGk5SfhcNQddehCBVbfeTH8KfVCdaxQ+F3MrRe8=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    flac
    gcc11.cc.lib
    libmicrohttpd
    llvmPackages_10.openmp
    qtcharts
    qtdeclarative
    qtquickcontrols2
    qtwebengine
    qtwebview
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p $out/bin
    cp ./usr/bin/* $out/bin

    # desktop files
    mkdir -p $out/share/applications
    cp ./usr/share/applications/* $out/share/applications

    # documentation
    mkdir -p $out/share/doc/${pname}
    cp ./usr/share/doc/hqplayer4desktop/* $out/share/doc/${pname}

    # pixmaps
    mkdir -p $out/share/pixmaps
    cp ./usr/share/pixmaps/* $out/share/pixmaps

    runHook postInstall
  '';

  postInstall = ''
    for desktopFile in $out/share/applications/*; do
      substituteInPlace "$desktopFile" \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/doc/ $out/share/doc/
    done
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so $out/bin/.hqplayer4desktop-wrapped
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software HD-audio player";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
