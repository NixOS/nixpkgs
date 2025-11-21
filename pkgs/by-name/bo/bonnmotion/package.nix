{
  stdenv,
  lib,
  fetchzip,
  replaceVars,
  bash,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bonnmotion";
  version = "3.0.1";

  # also available at https://github.com/sys-uos/bonnmotion
  src = fetchzip {
    url = "https://bonnmotion.sys.cs.uos.de/src/bonnmotion-${finalAttrs.version}.zip";
    sha256 = "16bjgr0hy6an892m5r3x9yq6rqrl11n91f9rambq5ik1cxjqarxw";
  };

  patches = [
    # The software has a non-standard install bash script which kind of works.
    # However, to make it fully functional, the automatically detection of the
    # program paths must be substituted with full paths.
    (replaceVars ./install.patch {
      inherit bash jre;
    })
  ];

  installPhase = ''
    runHook preInstall

    ./install

    mkdir -p $out/bin $out/share/bonnmotion
    cp -r ./classes ./lib $out/share/bonnmotion/
    cp ./bin/bm $out/bin/

    substituteInPlace $out/bin/bm \
      --replace-fail "$PWD" $out/share/bonnmotion

    runHook postInstall
  '';

  meta = {
    description = "Mobility scenario generation and analysis tool";
    mainProgram = "bm";
    longDescription = ''
      BonnMotion is a Java software which creates and analyzes mobility
      scenarios and is most commonly used as a tool for the investigation of
      mobile ad hoc network characteristics. The scenarios can also be exported
      for several network simulators, such as ns-2, ns-3, GloMoSim/QualNet,
      COOJA, MiXiM, and ONE.
    '';
    homepage = "https://bonnmotion.sys.cs.uos.de";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependency jars
    ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ oxzi ];
  };
})
