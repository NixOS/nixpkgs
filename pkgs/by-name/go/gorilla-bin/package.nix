{
  fetchurl,
  makeWrapper,
  patchelf,
  lib,
  stdenv,
  libxft,
  libx11,
  freetype,
  fontconfig,
  libxrender,
  libxscrnsaver,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gorilla-bin";
  version = "1.5.3.7";

  src = fetchurl {
    name = "gorilla1537_64.bin";
    url = "http://gorilla.dp100.com/downloads/gorilla1537_64.bin";
    sha256 = "19ir6x4c01825hpx2wbbcxkk70ymwbw4j03v8b2xc13ayylwzx0r";
  };

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];

  unpackCmd = ''
    mkdir gorilla;
    cp $curSrc gorilla/gorilla-${finalAttrs.version};
  '';

  installPhase =
    let
      interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
      libPath = lib.makeLibraryPath [
        libxft
        libx11
        freetype
        fontconfig
        libxrender
        libxscrnsaver
        libxext
      ];
    in
    ''
      mkdir -p $out/opt/password-gorilla
      mkdir -p $out/bin
      cp gorilla-${finalAttrs.version} $out/opt/password-gorilla
      chmod ugo+x $out/opt/password-gorilla/gorilla-${finalAttrs.version}
      patchelf --set-interpreter "${interpreter}" "$out/opt/password-gorilla/gorilla-${finalAttrs.version}"
      makeWrapper "$out/opt/password-gorilla/gorilla-${finalAttrs.version}" "$out/bin/gorilla" \
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
})
