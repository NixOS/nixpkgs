{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs_22,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "jellystat";
  version = "1.1.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CyferShepard";
    repo = "Jellystat";
    tag = finalAttrs.version;
    hash = "sha256-DVWo6zeEOAE3EaCXmN1JYouCvyG1lx4OrJP3BGnjumo=";
  };

  patches = [
    ./remove-hardcoded-path.patch
  ];

  npmDepsFetcherVersion = 2;

  npmDepsHash = "sha256-hVvwjm3oY9NBVP98Vf2cBkDY7N9AeIL2PauSuk2NaVM=";

  makeCacheWritable = true;

  nodejs = nodejs_22;

  npmPackFlags = [ "--ignore-scripts" ];
  npmFlags = [ "--legacy-peer-deps" ];

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  postPatch = ''
    substituteInPlace backend/server.js \
      --replace-fail "const PORT = 3000;" "const PORT = Number(process.env.JS_PORT || 3000);"
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jellystat $out/bin
    cp -r . $out/share/jellystat/

    makeWrapper ${nodejs_22}/bin/node $out/bin/jellystat \
      --chdir $out/share/jellystat \
      --add-flags $out/share/jellystat/backend/server.js

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Jellystat is a free and open source Statistics App for Jellyfin";
    homepage = "https://github.com/CyferShepard/Jellystat";
    license = licenses.mit;
    maintainers = with maintainers; [ mistyttm ];
    mainProgram = "jellystat";
    platforms = platforms.all;
  };
})
