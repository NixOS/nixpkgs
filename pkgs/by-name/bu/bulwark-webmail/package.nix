{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  geist-font,
  nodejs-slim,
}:
buildNpmPackage (finalAttrs: {
  pname = "bulwark-webmail";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "bulwarkmail";
    repo = "webmail";
    tag = finalAttrs.version;
    hash = "sha256-u4m3S33zH+1TUlexQk3HSM4lMhNbXRdax7LZPx9DCww=";
  };

  npmDepsHash = "sha256-q80VsVyGj/a5Fzf2DqNWMPXQdhFafiGJeJJ23gWduMU=";

  patches = [ ./font-lookup.patch ];

  postPatch = ''
    cp ${geist-font}/share/fonts/opentype/Geist{,Mono}-Regular.otf .
  '';

  installPhase = ''
    mkdir -p $out/share/bulwark-webmail $out/bin
    cp -r .next/standalone/. $out/share/bulwark-webmail
    cp -r .next/static $out/share/bulwark-webmail/.next/static
    cp -r public $out/share/bulwark-webmail/public

    makeWrapper "${lib.getExe nodejs-slim}" "$out/bin/bulwark-webmail" \
      --add-flags "$out/share/bulwark-webmail/server.js" \
  '';

  __structuredAttrs = true;

  meta = {
    mainProgram = "bulwark-webmail";
    description = "Self-hosted JMAP webmail for Stalwart Mail Server.";
    homepage = "https://bulwarkmail.org/";
    changelog = "https://github.com/bulwarkmail/webmail/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
