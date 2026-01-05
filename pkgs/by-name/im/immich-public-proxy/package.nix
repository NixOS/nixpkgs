{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  nodejs,
}:
buildNpmPackage rec {
  pname = "immich-public-proxy";
  version = "1.14.2";
  src = fetchFromGitHub {
    owner = "alangrainger";
    repo = "immich-public-proxy";
    tag = "v${version}";
    hash = "sha256-+A32kg232mRFRX/7t+etDOKG5bAc9A+Kepvcr+JmDhA=";
  };

  sourceRoot = "${src.name}/app";

  npmDepsHash = "sha256-PHsKi5wBXZPbTpYIg3pCZSxB7Up/Xtaam1dUGy8zLk0=";

  # patch in absolute nix store paths so the process doesn't need to cwd in $out
  postPatch = ''
    substituteInPlace src/index.ts --replace-fail \
      "const app = express()" \
      "const app = express()
    // Set the views path to the nix output
    app.set('views', '$out/lib/node_modules/immich-public-proxy/views')" \
    --replace-fail \
      "static('public'" \
      "static('$out/lib/node_modules/immich-public-proxy/public'"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich-public-proxy;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/alangrainger/immich-public-proxy/releases/tag/${src.tag}";
    description = "Share your Immich photos and albums in a safe way without exposing your Immich instance to the public";
    homepage = "https://github.com/alangrainger/immich-public-proxy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jaculabilis ];
    inherit (nodejs.meta) platforms;
    mainProgram = "immich-public-proxy";
  };
}
