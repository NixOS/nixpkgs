{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "layout-card";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-layout-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xni9cTgv5rdpr+Oo4Zh/d/2ERMiqDiTFGAiXEnigqjc=";
  };

  npmDepsHash = "sha256-Nmi51kCj/e9A0PmO/DIvOplgBnQzIEmCbuM5HjmdKGw=";

  # drop the prebuilt bundle checked into the repo, so the build regenerates it
  postPatch = ''
    rm layout-card.js
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 layout-card.js $out/layout-card.js

    runHook postInstall
  '';

  meta = {
    description = "Get more control over the placement of lovelace cards";
    homepage = "https://github.com/thomasloven/lovelace-layout-card";
    changelog = "https://github.com/thomasloven/lovelace-layout-card/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
