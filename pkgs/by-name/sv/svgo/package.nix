{
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  stdenv,
  pnpm_11,
  fetchPnpmDeps,
  pnpmBuildHook,
  pnpmConfigHook,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "svgo";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "svg";
    repo = "svgo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fwSuYPv9y16r6fCmxzqynTaq4FdrplNRrNH30tagJgI=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src version;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-Gu0Pi+WW485VpKU/QAiyUVnsPGpeypXJmVFLBiK1f2o=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    pnpmBuildHook
    makeWrapper
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
