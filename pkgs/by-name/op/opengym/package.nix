{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nodejs-slim,
  callPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "opengym";
  version = "1.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DuarteSantos8";
    repo = "openGym";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YkuPELGnAfjmC/CK7SR/c2OhyP+VdLgK/O2qmDKn/Sw=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";
  npmDepsHash = "sha256-qjLSyj/CV0nSgiNLx6EzXyXEWuAmP3hwe5enfgO+pjM=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev

    mkdir -p $out/lib/opengym $out/bin
    cp -r . $out/lib/opengym/

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/opengym \
      --add-flags "$out/lib/opengym/server.js" \
      --set NODE_ENV production

    runHook postInstall
  '';

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) src version;
    };
    media = callPackage ./media.nix {
      inherit (finalAttrs) src version;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted workout tracker";
    homepage = "https://github.com/DuarteSantos8/openGym";
    changelog = "https://github.com/DuarteSantos8/openGym/releases/tag/v${finalAttrs.version}";
    mainProgram = "opengym";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = nodejs-slim.meta.platforms;
  };
})
