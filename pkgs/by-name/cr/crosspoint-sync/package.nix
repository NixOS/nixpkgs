{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  nixosTests,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "crosspoint-sync";
  version = "d35a853";

  src = fetchFromGitHub {
    owner = "crosspoint-reader";
    repo = "crosspoint-sync";
    rev = "d35a8531520eafa832574e8c860d1deedcb72e37";
    hash = "sha256-iMDC2AGIGDowkL7RRSWFCSWEgekYxdPblq4Ve+36MME=";
  };

  npmDepsHash = "sha256-kn3etI5vqGfPs+tsIGpNYqWcVJ8je/zBaPiUJKbYQTg=";

  # Upstream requires node:sqlite, which is only stable from Node 24 on.
  nodejs = nodejs_24;

  nativeBuildInputs = [ makeWrapper ];

  # dist/ is gitignored, so the default `npm pack` installer would ship the
  # TypeScript sources without the compiled output. Install the layout the
  # server expects instead: it resolves migrations/, assets/ and extension/
  # relative to dist/, exactly as the upstream image lays them out.
  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-save $npmFlags "''${npmFlagsArray[@]}"
    # Pruned dev dependencies leave their scope directories behind.
    find node_modules -maxdepth 1 -type d -empty -delete

    mkdir -p $out/lib/crosspoint-sync
    cp -r dist migrations assets extension node_modules package.json $out/lib/crosspoint-sync/

    makeWrapper ${lib.getExe nodejs_24} $out/bin/crosspoint-sync \
      --add-flags $out/lib/crosspoint-sync/dist/index.js \
      --set-default NODE_ENV production

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) crosspoint-sync; };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "KOSync-compatible sync server for CrossPoint/CrossInk and KOReader e-readers";
    longDescription = ''
      A self-hostable sync server for CrossPoint / CrossInk e-readers and any
      KOReader device. It speaks the stock kosync protocol, stores reading
      progress per device, and additionally syncs bookmarks, clippings and
      reading statistics. Optional connectors push reading state to external
      services such as Hardcover, Micro.blog, Audiobookshelf and Readwise.
    '';
    homepage = "https://github.com/crosspoint-reader/crosspoint-sync";
    license = lib.licenses.mit;
    mainProgram = "crosspoint-sync";
    maintainers = with lib.maintainers; [ notthebee ];
  };
})
