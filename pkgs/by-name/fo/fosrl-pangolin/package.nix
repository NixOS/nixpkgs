{
  lib,
  fetchFromGitHub,
  esbuild,
  buildNpmPackage,
  inter,
  databaseType ? "sqlite",
}:

assert lib.assertOneOf "databaseType" databaseType [
  "sqlite"
  "pg"
];

let
  db =
    isLong:
    if (databaseType == "sqlite") then
      "sqlite"
    else if isLong then
      "postgresql"
    else
      "pg";
in

buildNpmPackage (finalAttrs: {
  pname = "pangolin";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "pangolin";
    tag = finalAttrs.version;
    hash = "sha256-8YGDDUmA6q7DVt+TcyHLrzLrV6jLC0GZq85V+3STBRY=";
  };

  npmDepsHash = "sha256-vLRhRfP+8pdEc9VusvBuD5Gyx+nqPQv0r+Zm5n0gqpE=";

  nativeBuildInputs = [ esbuild ];

  prePatch = ''
    rm server/db/index.ts

    cat > server/db/index.ts << EOF
    export * from "./${db false}";
    EOF
  '';

  # Replace the googleapis.com Inter font with a local copy from Nixpkgs.
  # Based on pkgs.nextjs-ollama-llm-ui.
  postPatch = ''
    substituteInPlace src/app/layout.tsx --replace-fail \
      "{ Inter } from \"next/font/google\"" \
      "localFont from \"next/font/local\""

    substituteInPlace src/app/layout.tsx --replace-fail \
      "Inter({ subsets: [\"latin\"] })" \
      "localFont({ src: './Inter.ttf' })"

    cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf
  '';

  preBuild = ''
    npx drizzle-kit generate --dialect ${db true} --schema ./server/db/${db false}/schema.ts --name migration --out init
  '';

  npmBuildScript = "build:${db false}";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    cp -r .next/standalone/* $out/
    cp -r .next/standalone/.next $out/

    cp -r .next/static $out/.next/static
    cp -r dist $out/dist
    cp -r init $out/dist/init

    cp server/db/names.json $out/dist/names.json
    cp -r public $out/public
    cp -r node_modules $out/
    runHook postInstall
  '';

  passthru = { inherit databaseType; };

  meta = {
    description = "Tunneled reverse proxy server with identity and access control";
    homepage = "https://github.com/fosrl/pangolin";
    changelog = "https://github.com/fosrl/pangolin/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
