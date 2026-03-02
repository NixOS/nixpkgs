{
  lib,
  fetchFromGitHub,
  esbuild,
  buildNpmPackage,
  makeWrapper,
  formats,
  inter,
  databaseType ? "sqlite",
  environmentVariables ? { },
  nixosTests,
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
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "pangolin";
    tag = finalAttrs.version;
    hash = "sha256-UGfwbFbuQ0ljipCjnPxZ/Is2hh1vjZJb97Lo/43sWeg=";
  };

  npmDepsHash = "sha256-kfgwU5QusUNWVcRXlYCS3ES1Av/phCHG8nFBj0yjz2Q=";

  nativeBuildInputs = [
    esbuild
    makeWrapper
  ];

  # Replace the googleapis.com Inter font with a local copy from Nixpkgs.
  # Based on pkgs.nextjs-ollama-llm-ui.
  postPatch = ''
    substituteInPlace src/app/layout.tsx --replace-fail \
      "{ Geist, Inter, Manrope, Open_Sans } from \"next/font/google\"" \
      "localFont from \"next/font/local\""

    substituteInPlace src/app/layout.tsx --replace-fail \
      "const font = Inter({${"\n"}    subsets: [\"latin\"]${"\n"}});" \
      "const font = localFont({ src: './Inter.ttf' });"

    cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf
  '';

  preBuild = ''
    npm run set:${db false}
    npm run set:oss
    npm run db:${db false}:generate
  '';

  buildPhase = ''
    runHook preBuild

    npm run build
    npm run build:cli

    runHook postBuild
  '';

  preInstall = "mkdir -p $out/{bin,share/pangolin}";

  installPhase = ''
    runHook preInstall

    cp -r node_modules $out/share/pangolin/node_modules
    cp -r .next/standalone/. $out/share/pangolin
    cp -r .next/static $out/share/pangolin/.next/static
    cp -r dist $out/share/pangolin/dist
    cp -r server/migrations $out/share/pangolin/dist/init
    cp package.json $out/share/pangolin/package.json

    cp server/db/names.json $out/share/pangolin/dist/names.json
    cp server/db/ios_models.json $out/share/pangolin/dist/ios_models.json
    cp server/db/mac_models.json $out/share/pangolin/dist/mac_models.json

    cp -r public $out/share/pangolin/public

    runHook postInstall
  '';

  preFixup =
    let
      defaultConfig = (formats.yaml { }).generate "pangolin-default-config" {
        app.dashboard_url = "https://pangolin.example.test";
        domains.domain1.base_domain = "example.test";
        gerbil.base_endpoint = "pangolin.example.test";
        server.secret = "A secret string used for encrypting sensitive data. Must be at least 8 characters long.";
      };
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
        # If we're running Pangolin, test if we have a .nix_skip_setup file in the public
        # and .next directories. If we don't, clean them up and re-create them.
        + lib.optionalString isServer " --run '${
           (lib.concatMapStringsSep " && "
             (
               dir:
               "test -f ${dir}/.nix_skip_setup || { rm -${lib.optionalString (dir == ".next") "r"}f ${dir} && ${
                 if (dir == ".next") then "cp -rd" else "ln -s"
               } ${placeholder "out"}/share/pangolin/${dir} .; }"
             )
             [
               ".next"
               "public"
               "node_modules"
             ]
           )
           # Also deploy a small config (if none exists) and run the
           # database migrations before running the server.
         } && test -f config/config.yml || { install -Dm600 ${defaultConfig} config/config.yml && { test -z $EDITOR && { echo \"Please edit $(pwd)/config/config.yml\" and run the server again. && exit 255; } || $EDITOR config/config.yml; }; } && command ${placeholder "out"}/bin/migrate-pangolin-database'";
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

  passthru = {
    inherit databaseType;
    tests = { inherit (nixosTests) pangolin; };
  };

  meta = {
    description = "Tunneled reverse proxy server with identity and access control";
    homepage = "https://github.com/fosrl/pangolin";
    changelog = "https://github.com/fosrl/pangolin/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pangolin";
  };
})
