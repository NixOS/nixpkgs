{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodejs_26,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-kubernetes-log-tailer";
  version = "12.0.33";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  sourceRoot = "${finalAttrs.src.name}/KubernetesLogTailer";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-P0EqLkWh/Cspbz/DRR7/FK6nGenAPOjLtrA6WbhFoYc=";

  npmBuildScript = "compile";

  # Prevent inclusion of dev deps since we override installPhase
  npmFlags = [ "--omit=dev" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      libDir = "$out/lib/oneuptime-kubernetes-log-tailer";
    in
    ''
      runHook preInstall

      install -d ${libDir}
      cp -a build/dist node_modules ${libDir}/

      makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-kubernetes-log-tailer \
        --add-flags ${libDir}/dist/Index.js

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent that forwards Kubernetes pod logs to OneUptime via OTLP";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-kubernetes-log-tailer";
    platforms = lib.platforms.linux;
  };
})
