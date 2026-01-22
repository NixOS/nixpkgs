{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  stdenv,
  yarn-berry_3,
}:

let
  yarn-berry = yarn-berry_3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "svgo";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "svg";
    repo = "svgo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSttRNHxcZquIxrTogk+7YS7rhp083qnOwJI71cmO20=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-DrIbnm0TWviCfylCI/12XYsx7YOIk7JFVV18Q4dImwU=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarn-berry.yarnBerryConfigHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/svgo"
    cp -r bin lib node_modules package.json plugins "$out/lib/svgo"
    makeWrapper '${lib.getExe nodejs}' "$out/bin/svgo" \
      --add-flags "$out/lib/svgo/bin/svgo.js"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/svg/svgo/releases/tag/${finalAttrs.src.tag}";
    description = "Node.js tool for optimizing SVG files";
    homepage = "https://github.com/svg/svgo";
    license = lib.licenses.mit;
    mainProgram = "svgo";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
