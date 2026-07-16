{
  stdenvNoCC,
  openbao,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  # https://github.com/openbao/openbao/issues/731
  nodejs-slim_22,
}:
let
  nodejs-slim = nodejs-slim_22;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = openbao.pname + "-ui";
  inherit (openbao) version src;
  sourceRoot = "${finalAttrs.src.name}/ui";

  nativeBuildInputs = [
    pnpmConfigHook
    pnpmBuildHook
    pnpm
    nodejs-slim
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-9Q5celZSwMgSS8qcj8sDH/JLv48lgDMOylANvXSnhsU=";
  };

  postConfigure = ''
    substituteInPlace .ember-cli \
      --replace-fail "../http/web_ui" "$out"
  '';

  dontInstall = true;

  meta = (builtins.removeAttrs openbao.meta [ "mainProgram" ]) // {
    description = openbao.meta.description + " - web UI";
  };
})
