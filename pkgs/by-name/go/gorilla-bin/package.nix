{ fetchurl, makeWrapper, patchelf, lib, stdenv, libXft, libX11, freetype, fontconfig, libXrender, libXScrnSaver, libXext }:

stdenv.mkDerivation rec {
  pname = "gorilla-bin";
  version = "1.5.3.7";

  src = fetchurl {
    name = "gorilla1537_64.bin";
    url = "http://gorilla.dp100.com/downloads/gorilla1537_64.bin";
    sha256 = "19ir6x4c01825hpx2wbbcxkk70ymwbw4j03v8b2xc13ayylwzx0r";
  };

  nativeBuildInputs = [ patchelf makeWrapper ];

  unpackCmd = ''
    mkdir gorilla;
    cp $curSrc gorilla/gorilla-${version};
  '';

  installPhase = let
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    libPath = lib.makeLibraryPath [ libXft libX11 freetype fontconfig libXrender libXScrnSaver libXext ];
  in ''
    mkdir -p $out/opt/password-gorilla
    mkdir -p $out/bin
    cp gorilla-${version} $out/opt/password-gorilla
    chmod ugo+x $out/opt/password-gorilla/gorilla-${version}
    patchelf --set-interpreter "${interpreter}" "$out/opt/password-gorilla/gorilla-${version}"
    makeWrapper "$out/opt/password-gorilla/gorilla-${version}" "$out/bin/gorilla" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = {
    description = "Password Gorilla is a Tk based password manager";
    mainProgram = "gorilla";
    homepage = "https://github.com/zdia/gorilla/wiki";
    maintainers = [ lib.maintainers.namore ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Plus;
  };
}
