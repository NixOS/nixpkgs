{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  nix-update-script,
  ant,
  jdk,
  air-sdk,
  air-runtime ? air-sdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apm";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "airsdk";
    repo = "apm";
    tag = finalAttrs.version;
    hash = "sha256-yi2Ye1urbyOy9Wd3MA+0jjrNI700l1CnMO2dS/tX/Po=";
  };

  ant_contrib = fetchurl {
    url = "https://search.maven.org/remotecontent?filepath=ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3.jar";
    hash = "sha256-vjOmmBgxC1xV5B3BHUjNiV9fEp2ksNKML0xsPhy88/w=";
  };

  nativeBuildInputs = [
    makeWrapper
    ant
    jdk
    air-sdk
  ];

  configurePhase = ''
    runHook preConfigure

    echo "air.sdk = $AIR_HOME" > build.config

    # https://github.com/airsdk/apm/blob/2.2.0/build.xml#L21
    export CLASSPATH=$ant_contrib

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/share/apm
    install -Dm755 client/out/apm -t $phome
    install -Dm644 client/out/apm.swf -t $phome
    install -Dm644 client/out/apm.xml -t $phome
    wrapProgram $phome/apm --set-default AIR_HOME ${air-runtime.passthru.runtime} --inherit-argv0
    mkdir -p $out/bin
    ln -s $phome/apm $out/bin/apm

    runHook postInstall
  '';

  postFixup = ''
    # https://github.com/airsdk/Adobe-Runtime-Support/discussions/3279
    sed -i 's|<application xmlns="http://ns.adobe.com/air/application/.*">|<application xmlns="http://ns.adobe.com/air/application/${lib.versions.majorMinor air-runtime.version}">|' $out/share/apm/apm.xml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AIR Package Manager";
    homepage = "https://github.com/airsdk/apm";
    downloadPage = "https://github.com/airsdk/apm/releases/tag/${finalAttrs.src.tag}";
    changelog = "https://github.com/airsdk/apm/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # ant-contrib
    ];
    mainProgram = "apm";
  };
})
