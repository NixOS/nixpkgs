{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  makeWrapper,
  jre,
  javaOpts ? "-Xms16g -Xmx16g",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "photon-geocoder";
  version = "1.1.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "komoot";
    repo = "photon";
    tag = finalAttrs.version;
    hash = "sha256-li7kCETzsRceWB2033bZkg2s4r0nBjFSiBRny6DA8DY=";
  };

  # gitHashProvider relies on git history being available in src
  postPatch = ''
    substituteInPlace "build.gradle" \
      --replace-fail "'Git-Commit': gitHashProvider" ""
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dfile.encoding=utf-8"
  ];

  gradleBuildTask = "build";

  doCheck = true;

  installPhase =
    let
      jarName = "photon-${finalAttrs.src.tag}.jar";
    in
    ''
      mkdir -p $out/{bin,share/photon}
      cp target/${jarName} $out/share/photon

      makeWrapper ${lib.getExe jre} $out/bin/photon \
        --add-flags "${javaOpts} -jar $out/share/photon/${jarName}"
    '';

  meta = {
    homepage = "https://github.com/komoot/photon";
    changelog = "https://github.com/komoot/photon/releases/tag/${finalAttrs.src.tag}";
    description = "Open source geocoder for openstreetmap data";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gigahawk ];
    mainProgram = "photon";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
