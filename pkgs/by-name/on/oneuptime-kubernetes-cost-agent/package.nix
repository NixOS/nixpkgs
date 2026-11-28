{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodejs_26,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-kubernetes-cost-agent";
  version = "14.0.28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-WeW9HxGNyR+Zh6M6e2lPgwHqHAjovxDROVsvYyEiY+s=";
  };

  sourceRoot = "${finalAttrs.src.name}/agents/KubernetesCostAgent";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-4XkTb5nJubNRFu7viVPv7aFR8Uz+A88Kp+2i3KCBku8=";

  npmBuildScript = "compile";

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      libDir = "$out/lib/oneuptime-kubernetes-cost-agent";
    in
    ''
      runHook preInstall

      install -d ${libDir}
      cp -a build/dist ${libDir}/

      makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-kubernetes-cost-agent \
        --add-flags ${libDir}/dist/Index.js

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent that reports Kubernetes workload cost allocations to OneUptime";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-kubernetes-cost-agent";
    platforms = lib.platforms.linux;
  };
})
