{
  autoPatchelfHook,
  coreutils-full,
  fetchzip,
  gtk2,
  lib,
  makeWrapper,
  stdenv,
  xorg,
}:

let
  platform =
    {
      "x86_64-linux" = "linux-x86-64";
      "i386-linux" = "linux-x86";
      "armv7-linux" = "linux-armv7";
      "armv6-linux" = "linux-armv6";
      "x86-64-darwin" = "macosx-x86-64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "eiffel-studio does not support architecture ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "eiffelstudio-bin";
  version = "19.05";
  build = "103187";
  libraries = [ ];
  src = fetchzip {
    url = "mirror://sourceforge/eiffelstudio/EiffelStudio%20${finalAttrs.version}/Build_${finalAttrs.build}/Eiffel_${finalAttrs.version}_gpl_${finalAttrs.build}-${platform}.tar.bz2";
    hash = "sha256-Tt4u4hydiIXB7FQnaoE/GtJt0gYRMOaVdDDUgMrDJtU=";
  };

  fixupPhase = ''
    runHook preFixup

    cd $out/studio/spec/${platform}/include/
    for cmd in "cp" "ln" "mv" "rm" "sed"; do
      substituteInPlace config.sh --replace-fail $cmd=\'/bin/$cmd\' $cmd=\'${lib.getBin coreutils-full}/bin/$cmd\'
    done

    substituteInPlace config.sh --replace-fail ld=\'\$LD\' ld=\'ld\'

    runHook postFixup
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk2
    xorg.libXtst
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r . $out

    for file in $out/studio/spec/${platform}/bin/*; do
      makeWrapper $file $out/bin/$(basename $file) \
        --set ISE_EIFFEL $out \
        --set ISE_PLATFORM ${platform}
    done

    ${lib.concatStringsSep "\n" (
      lib.forEach finalAttrs.libraries (elib: "ln -s ${elib}/lib/* $out/contrib/library/")
    )}

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.eiffel.com/eiffelstudio/";
    description = "IDE for one programming language, Eiffel";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aceroph ];
    mainProgram = "estudio";
  };
})
