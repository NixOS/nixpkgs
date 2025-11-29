{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  pkg-config,
  libsecret,
  stdenv,
}:
buildNpmPackage rec {
  pname = "some-sass-language-server";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "wkillerud";
    repo = "some-sass";
    tag = "some-sass-language-server@${version}";
    hash = "sha256-rtoHrnMAf3xa1U9vkhPiQ17gsY2yW2knjctod3TbKuo=";
  };

  npmDepsHash = "sha256-8jKrxqn8jSWUjZURHl53STTD4hcU0Q3iPH9E4r+lKTc=";

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  npmInstallFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ libsecret ];

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    echo "Building vscode-css-languageservice..."
    npm run build --workspace=packages/vscode-css-languageservice

    echo "Building language-services..."
    npm run build --workspace=packages/language-services

    echo "Building language-server..."
    npm run build:production --workspace=packages/language-server

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/some-sass-language-server
    cp -r packages/language-server/dist \
    packages/language-server/bin \
    packages/language-server/package.json \
    $out/lib/node_modules/some-sass-language-server/

    mkdir -p $out/bin
    ln -s $out/lib/node_modules/some-sass-language-server/bin/some-sass-language-server \
    $out/bin/some-sass-language-server

    runHook postInstall
  '';

  meta = {
    description = "Language server with advanced feature support for Scss and Sass files";
    homepage = "https://wkillerud.github.io/some-sass/";
    changelog = "https://github.com/wkillerud/some-sass/releases/tag/some-sass-language-server@${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roverp ];
    mainProgram = "some-sass-language-server";
  };
}
