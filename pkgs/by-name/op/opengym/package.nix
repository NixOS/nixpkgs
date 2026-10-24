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
  version = "1.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DuarteSantos8";
    repo = "openGym";
    tag = "v${finalAttrs.version}";
    hash = "sha256-666vHSvUy/eyKEgBaLkh7tb4k1U9LfI6BzhoZ7V5BuI=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";
  npmDepsHash = "sha256-5C8jWwbjqLtymGRh1jK+eZhN+/hXE2JwEQP1gvUWOlI=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/lib/opengym $out/bin
    cp -r . $out/lib/opengym/

    makeWrapper ${nodejs-slim}/bin/node $out/bin/opengym \
      --add-flags "$out/lib/opengym/server.js" \
      --set NODE_ENV production
  '';

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) src version;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted workout tracker";
    homepage = "https://github.com/DuarteSantos8/openGym";
    mainProgram = "opengym";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = lib.platforms.linux;
  };
})
