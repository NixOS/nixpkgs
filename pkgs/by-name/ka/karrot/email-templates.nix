{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karrot-email-templates";
  version = "17.4.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "karrot";
    repo = "karrot-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aCfbFBN89ToYASmxpeaKzi7+BXtyfqlPr4EmXmTYRHA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/mjml/yarn.lock";
    hash = "sha256-4bgN0Wm0jueYnc81Seq5sNP0vZE32JobQZnV7ffyXxw=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
  ];

  postPatch = ''
    cp mjml/yarn.lock yarn.lock
    cp mjml/package.json package.json
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline --frozen-lockfile
    node mjml/convert

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r karrot $out/
    find $out -type f -not -name "*.html.jinja2" -delete
    find $out -empty -type d -delete

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compiled email templates for Karrot";
    homepage = "https://codeberg.org/karrot/karrot-backend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ phanirithvij ];
    teams = with lib.teams; [ ngi ];
  };
})
