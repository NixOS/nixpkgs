{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
}:

buildNpmPackage rec {
  pname = "scrobblex";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ryck";
    repo = "scrobblex";
    tag = "v${version}";
    hash = "sha256-rNtuditjzCdpBUnheM/Y+88cB8b/PZKF5U2Bczo1vdw=";
  };

  npmDepsHash = "sha256-2kgqQr0oiCIcUEkvnqDsmlKK9UdDKYxtLYDJ9+gMkNA=";

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/scrobblex
    cp -r src views static favicon.ico package.json node_modules $out/lib/scrobblex/

    makeWrapper ${lib.getExe nodejs} $out/bin/scrobblex \
      --add-flags "$out/lib/scrobblex/src/index.js" \
      --chdir "$out/lib/scrobblex"

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted Plex scrobbling integration with Trakt via webhooks";
    longDescription = ''
      Scrobblex is a self-hosted Node.js application that listens for Plex (or
      Tautulli) webhooks and scrobbles your watched media to Trakt. It also
      supports pushing Plex ratings back to Trakt.
    '';
    homepage = "https://github.com/ryck/scrobblex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ msaxena ];
    mainProgram = "scrobblex";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
