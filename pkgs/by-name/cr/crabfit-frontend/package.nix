{
  lib,
  nixosTests,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fetchpatch,
  nodejs,
  yarn,
  fixup_yarn_lock,
  google-fonts,
  api_url ? "http://127.0.0.1:3000",
  frontend_url ? "crab.fit",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crabfit-frontend";
  version = "0-unstable-2023-08-02";

  src = fetchFromGitHub {
    owner = "GRA0007";
    repo = "crab.fit";
    rev = "628f9eefc300bf1ed3d6cc3323332c2ed9b8a350";
    hash = "sha256-jy8BrJSHukRenPbZHw4nPx3cSi7E2GSg//WOXDh90mY=";
  };

  sourceRoot = "source/frontend";

  patches = [
    ./01-localfont.patch
    (fetchpatch {
      name = "02-standalone-app.patch";
      url = "https://github.com/GRA0007/crab.fit/commit/6dfd69cd59784932d195370eb3c5c87589609c9f.patch";
      relative = "frontend";
      hash = "sha256-XV7ia+flcUU6sLHdrMjkPV7kWymfxII7bpoeb/LkMQE=";
    })
    ./03-frontend-url.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/frontend/yarn.lock";
    hash = "sha256-jkyQygwHdLlEZ1tlSQOh72nANp2F29rZbTXvKQStvGc=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    fixup_yarn_lock
  ];

  postPatch = ''
    substituteInPlace \
      public/robots.txt \
      public/sitemap.xml \
      src/app/\[id\]/page.tsx \
      src/app/layout.tsx \
      src/components/CreateForm/components/EventInfo/EventInfo.tsx \
      src/i18n/locales/de/help.json \
      src/i18n/locales/en-GB/help.json \
      src/i18n/locales/en/help.json \
      src/i18n/locales/es/help.json \
      src/i18n/locales/fr/help.json \
      src/i18n/locales/hi/help.json \
      src/i18n/locales/id/help.json \
      src/i18n/locales/it/help.json \
      src/i18n/locales/ko/help.json \
      src/i18n/locales/pt-BR/help.json \
      src/i18n/locales/pt-PT/help.json \
      src/i18n/locales/ru/help.json \
      --replace-fail "@FRONTEND_URL@" "${frontend_url}"
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$PWD"

    echo 'NEXT_PUBLIC_API_URL="${api_url}"' > .env.local

    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules

    mkdir -p src/app/fonts
    cp "${
      google-fonts.override { fonts = [ "Karla" ]; }
    }/share/fonts/truetype/Karla[wght].ttf" src/app/fonts/karla.ttf

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    NODE_ENV=production yarn build

    runHook postBuild
  '';

  installPhase = ''
    mkdir $out
    cp -R .next/* $out
    cp -R public $out/standalone/
    cp -R .next/static $out/standalone/.next

    ln -s /var/cache/crabfit $out/standalone/.next/cache
  '';

  passthru.tests = [ nixosTests.crabfit ];

  meta = {
    description = "Enter your availability to find a time that works for everyone";
    homepage = "https://github.com/GRA0007/crab.fit";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
  };
})
