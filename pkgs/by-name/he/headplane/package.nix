{
  fetchFromGitHub,
  git,
  lib,
  makeWrapper,
  nodejs_22,
  pnpm_10,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "headplane";
  version = "0.5.10";
  src = fetchFromGitHub {
    repo = "tale";
    owner = "headplane";
    rev = finalAttrs.version;
    hash = "sha256-0sckkbjyjrgshzmxx1biylxasybcmybarmqgfhl2cn6yy40dw6p4";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
    pnpm_10.configHook
    git
  ];

  dontCheckForBrokenSymlinks = true;

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-GtpwQz7ngLpP+BubH6uaG1uUZsZdCQzvTI1WKBYU2T4=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/headplane}
    cp -r build $out/share/headplane/
    sed -i "s;$PWD;../..;" $out/share/headplane/build/server/index.js
    makeWrapper ${lib.getExe nodejs_22} $out/bin/headplane \
        --chdir $out/share/headplane \
        --add-flags $out/share/headplane/build/server/index.js
    runHook postInstall
  '';

  meta = {
    description = "A feature-complete Web UI for Headscale";
    homepage = "https://github.com/tale/headplane";
    changelog = "https://github.com/tale/headplane/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.igor-ramazanov ];
    mainProgram = "headplane";
    platforms = lib.platforms.linux;
  };
})
