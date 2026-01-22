{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "peerflix-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "asapach";
    repo = "peerflix-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-on1k6ONCI267h+hXlF0kveLFO5KSoEI1EqFCbphYMhI=";
  };

  npmDepsHash = "sha256-1RCuVZcasFmuPXyGlHxUE1AB5rCeVk2ctst2z1X5Ubw=";

  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Streaming torrent client for Node.js with web ui";
    homepage = "https://github.com/asapach/peerflix-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "peerflix-server";
  };
})
