{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  google-fonts,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "bulwark";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "bulwarkmail";
    repo = "webmail";
    tag = finalAttrs.version;
    hash = "sha256-jrjqnKuuQZvO4ImTlWo8gGjapjw+9DtTKcq7E3LI/W4=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  npmDepsHash = "sha256-PMAJKGR3Su3Vje5gVJZlh4+xZkpWQxQfOF7faOmqN2U=";

  strictDeps = true;

  patches = [ ./01-localfont.patch ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p app/fonts
    cp "${
      google-fonts.override { fonts = [ "Geist" ]; }
    }/share/fonts/truetype/Geist[wght].ttf" app/fonts/Geist.ttf
    cp "${
      google-fonts.override { fonts = [ "GeistMono" ]; }
    }/share/fonts/truetype/GeistMono[wght].ttf" app/fonts/GeistMono.ttf

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    NEXT_TELEMETRY_DISABLED=1 GIT_COMMIT=$(cat COMMIT) node_modules/.bin/next build --webpack

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R .next/standalone/. $out/
    cp -R public $out/public
    cp -R .next/static $out/.next/static

    makeWrapper ${nodejs}/bin/node $out/bin/bulwark \
      --add-flags "$out/server.js" \
      --set NODE_ENV production \
      --set NEXT_TELEMETRY_DISABLED 1

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, self-hosted webmail client for Stalwart Mail Server";
    homepage = "https://bulwarkmail.org";
    changelog = "https://github.com/bulwarkmail/webmail/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "bulwark";
  };
})
