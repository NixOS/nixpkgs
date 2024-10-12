{
  lib,
  fetchurl,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_8,
  wails,
  wrapGAppsHook3,
}:

let
  # is this reproducible?
  fonts-declarations = fetchurl {
    name = "satisfactorymodmanager-font-declarations.css";
    url = "https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible&family=Roboto&family=Roboto+Mono&family=Material+Icons&family=Noto+Color+Emoji&display=swap";
    hash = "sha256-h0y8wHmpYbJsd3ywqHuLyGM8oeqY59QwOUcFgGnMZ+Q=";
  };
in
buildGoModule rec {
  pname = "satisfactorymodmanager";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "SatisfactoryModManager";
    rev = "refs/tags/v${version}";
    hash = "sha256-Gdi//VQJioTipi5dMs5JMZa1ZrZDdIfreAL59k3h/jQ=";
  };

  postPatch = ''
    substituteInPlace frontend/src/_global.postcss \
        --replace-fail "@import '${fonts-declarations.url}';" "$(< ${fonts-declarations})"

    substituteInPlace frontend/package.json \
        --replace-fail '"postinstall":' '"_postinstall":'

    rm -r frontend/src/lib/generated/graphql
    cp -r --no-preserve=all ${./generated/i18n} frontend/src/lib/generated/i18n
    cp -r --no-preserve=all ${./generated/graphql} frontend/src/lib/generated/graphql
  '';

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
    wails
    wrapGAppsHook3
  ];

  # we use env because buildGoModule doesn't forward all normal attrs
  # this is pretty hacky
  env = {
    pnpmDeps = pnpm_8.fetchDeps {
      inherit pname version src;
      sourceRoot = "${src.name}/frontend";
      hash = "sha256-OP+3zsNlvqLFwvm2cnBd2bj2Kc3EghQZE3hpotoqqrQ=";
    };

    pnpmRoot = "frontend";
  };

  # running this caches some additional dependencies for the FOD
  overrideModAttrs = {
    preBuild = ''
      wails build
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-JXPks36ABy0jKMOJypenazrm2zoRoU4rHB6pQwiSGP8=";

  buildPhase = ''
    runHook preBuild
    wails build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/bin/SatisfactoryModManager -t "$out/bin"
    runHook postInstall
  '';

  meta = {
    description = "Mod manager and modloader for Satisfactory";
    homepage = "https://github.com/satisfactorymodding/SatisfactoryModManager";
    license = lib.licenses.gpl3Only;
    mainProgram = "SatisfactoryModManager";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
