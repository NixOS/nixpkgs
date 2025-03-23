{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  # Gradle 8 complains about implicit task dependencies when using `installDist`.
  # See https://github.com/marytts/marytts/issues/1112
  gradle_7,
  makeWrapper,
  jdk,
  nixosTests,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "marytts";
  version = "5.2.1-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "marytts";
    repo = "marytts";
    rev = "1c2aaa0751b7cef8ae83216dd78b4c61232b3840";
    hash = "sha256-jGpsD6IwJ67nDLnulBn8DycXCyowssSnDCkQXBIfOH8=";
  };

  nativeBuildInputs = [
    gradle_7
    makeWrapper
  ];

  mitmCache = gradle_7.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # Required for the MITM cache to function
  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "installDist";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv build/install/source/{lib,user-dictionaries} $out

    makeWrapper ${lib.getExe jdk} $out/bin/marytts-server \
      --add-flags "-cp \"$out/lib/*\"" \
      --append-flags "marytts.server.Mary"

    # We skip the GUI installer since frankly it is a PITA to get to work with a hardened systemd service,
    # and the imperative installation paradigm is not ideal either way while using Nix.

    runHook postInstall
  '';

  passthru.tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
    nixos = nixosTests.marytts;
  };

  meta = {
    description = "Open-source, multilingual text-to-speech synthesis system written in pure Java";
    homepage = "https://marytts.github.io/";
    license = lib.licenses.lgpl3Only;
    inherit (jdk.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "marytts-server";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # Gradle dependencies
    ];
  };
})
