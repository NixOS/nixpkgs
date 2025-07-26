{
  lib,
  fetchFromGitHub,
  esbuild,
  buildNpmPackage,
  makeWrapper,
  inter,
  databaseType ? "sqlite",
  environmentVariables ? { },
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
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "pangolin";
    tag = finalAttrs.version;
    hash = "sha256-w4IyLdah/MdFrk8kjGpg4ci+LEDCCYRsy1VPdDyNyXI=";
  };

  npmDepsHash = "sha256-OGqYmOO6pizcOrdaoSGgjDQgqpjU0SIw3ceh57eyjr4=";

  nativeBuildInputs = [
    esbuild
    makeWrapper
  ];

  prePatch = ''
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

  postBuild = ''
    npm run build:cli
  '';

  preInstall = ''
    mkdir -p $out/{bin,share/pangolin}
  '';

  installPhase = ''
    runHook preInstall

    cp -r node_modules $out/share/pangolin

    cp -r .next/standalone/.next $out/share/pangolin
    cp .next/standalone/package.json $out/share/pangolin

    cp -r .next/static $out/share/pangolin/.next/static
    cp -r public $out/share/pangolin/public

    cp -r dist $out/share/pangolin/dist
    cp -r init $out/share/pangolin/dist/init

    cp server/db/names.json $out/share/pangolin/dist/names.json

    runHook postInstall
  '';

  postInstall = ''
    sed -i '1i #! /usr/bin/env node' $out/share/pangolin/dist/{migrations,server}.mjs
    chmod +x $out/share/pangolin/dist/{cli,migrations,server}.mjs
  '';

  preFixup =
    let
      variablesMapped =
        isServer:
        (lib.concatMapAttrsStringSep " " (name: value: "--set ${name} ${value}") (
          {
            NODE_OPTIONS = "enable-source-maps";
            NODE_ENV = "development";
            ENVIRONMENT = "prod";
          }
          // environmentVariables
        ))
        + lib.optionalString isServer " --run '${
           (lib.concatMapStringsSep " && "
             (dir: "test -L ${dir} || test -d ${dir} || ln -s ${placeholder "out"}/share/pangolin/${dir} .")
             [
               ".next"
               "public"
             ]
           )
         } && command ${placeholder "out"}/bin/migrate-pangolin-database'";
    in
    lib.concatMapStrings
      (
        attr:
        "makeWrapper $out/share/pangolin/dist/${attr.mjs}.mjs $out/bin/${attr.command} ${
          variablesMapped (attr.mjs == "server")
        }\n"
      )
      [
        {
          mjs = "cli";
          command = "pangctl";
        }
        {
          mjs = "migrations";
          command = "migrate-pangolin-database";
        }
        {
          mjs = "server";
          command = "pangolin";
        }
      ];

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
    mainProgram = "pangolin";
  };
})
