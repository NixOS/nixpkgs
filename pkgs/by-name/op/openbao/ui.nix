{
  stdenvNoCC,
  openbao,
  yarn-berry_3,
  nodejs_22,
}:
let

  yarn = yarn-berry_3.override { nodejs = nodejs_22; };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = openbao.pname + "-ui";
  inherit (openbao) version src;
  sourceRoot = "${finalAttrs.src.name}/ui";

  offlineCache = yarn.fetchYarnBerryDeps {
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-XK3ZVnzOTbFzrpPgaz1cx7okTycLhrvBHk9P2Nwv1cg=";
  };

  nativeBuildInputs = [
    yarn.yarnBerryConfigHook
    nodejs_22
    yarn
  ];

  env.YARN_ENABLE_SCRIPTS = 0;

  preConfigure = ''
    printYarnErrors() {
      cat /build/*.log
    }
    failureHooks+=(printYarnErrors)
  '';

  postConfigure = ''
    substituteInPlace .ember-cli \
      --replace-fail "../http/web_ui" "$out"
  '';

  buildPhase = ''
    runHook preBuild
    yarn run ember build --environment=production
    runHook postBuild
  '';

  dontInstall = true;

  meta = (builtins.removeAttrs openbao.meta [ "mainProgram" ]) // {
    description = openbao.meta.description + " - web UI";
  };
})
