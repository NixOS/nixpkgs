{
  fetchFromGitHub,
  fetchPnpmDeps,
  gradle_9,
  jdk25,
  lib,
  makeWrapper,
  nixosTests,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
}:

let
  gradle = gradle_9;
  jdk = jdk25;
  pnpm = pnpm_10;
  nodejs = nodejs_24;

  pname = "peerbanhelper";
  version = "9.2.2";

  src = fetchFromGitHub {
    owner = "PBH-BTN";
    repo = "PeerBanHelper";
    rev = "v${version}";
    hash = "sha256-zVV7d7NAmECyZr7Pner2bRWwtDxZDs6EJ6VjTmXVSsA=";
    leaveDotGit = true;
  };

  webui = stdenv.mkDerivation {
    pname = "${pname}-webui";
    inherit version src;
    sourceRoot = "${src.name}/webui";

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit pname version src;
      fetcherVersion = 3;
      sourceRoot = "${src.name}/webui";
      hash = "sha256-qrA+BIj9JLELP0HvjJVLUxaSepSQ1Q0aP1kKFMwaUng=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

in
stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    gradle
    jdk
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    mkdir -p src/main/resources/static
    cp -r ${webui}/* src/main/resources/static/
    chmod -R u+w src/main/resources/static
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java $out/bin $out/share/doc/${pname}
    cp build/libs/PeerBanHelper.jar $out/share/java/${pname}.jar
    cp -r build/libraries $out/share/java/

    cp src/main/resources/config.yml $out/share/doc/${pname}/config.example.yml
    cp src/main/resources/profile.yml $out/share/doc/${pname}/profile.example.yml

    echo "Managed by Nix" > $out/share/java/disable-checking-updates.txt

    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}.jar" \
      --set PBH_USEPLATFORMCONFIGLOCATION "true" \
      --set PBH_RELEASE "nix"

    runHook postInstall
  '';

  passthru.tests.peerbanhelper = nixosTests.peerbanhelper;

  meta = {
    description = "Automatically block unwanted, leeches and abnormal BT peers";
    homepage = "https://github.com/PBH-BTN/PeerBanHelper";
    changelog = "https://github.com/PBH-BTN/PeerBanHelper/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Misaka13514 ];
    mainProgram = "peerbanhelper";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
