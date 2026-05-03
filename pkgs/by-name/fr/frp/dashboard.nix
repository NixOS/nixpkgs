{
  buildNpmPackage,
  src,
  version,
}:
let
  builder =
    name:
    buildNpmPackage {
      pname = "${name}-dashboard";
      inherit version src;

      sourceRoot = "source/web";

      buildPhase = ''
        runHook preBuild
        cd ${name}
        npm run build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';

      npmDepsHash = "sha256-ZScKHx3WhXb/BzGsm4vrWjxeL/K8zfBmectBr66iKFQ=";
    };
in
{
  frpc = builder "frpc";
  frps = builder "frps";
}
