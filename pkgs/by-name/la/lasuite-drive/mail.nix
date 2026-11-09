{
  src,
  version,
  meta,
  stdenv,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-drive-mail";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/src/mail";

  postPatch = ''
    substituteInPlace bin/html-to-plain-text bin/mjml-to-html \
      --replace-fail \
        '../backend/core/templates/mail' \
        '${placeholder "out"}'
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/mail/yarn.lock";
    hash = "sha256-UPIb9QJk+zC8wYeBeDnmlGLhHDhsEOoT+qquFM1XyqU=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  dontInstall = true;

  __structuredAttrs = true;

  meta = meta // {
    description = "HTML mail templates for LaSuite Drive";
  };
})
