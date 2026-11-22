{
  buildNpmPackage,
  frp,
}:
let
  builder =
    name:
    buildNpmPackage {
      pname = "${name}-dashboard";
      inherit (frp) version src;

      sourceRoot = "source/web";

      preBuild = ''
        pushd ${name}
      '';

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';

      npmDepsHash = "sha256-yiQK196bsGijjA9VyWSnWgK9k6o39a098YELOTfyScU";

      meta = frp.meta // {
        description = "Dashboard for frp";
      };
    };
in
{
  frpc = builder "frpc";
  frps = builder "frps";
}
