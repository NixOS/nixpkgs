{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  preferLocalBuild = true;
  pname = "freescout";
  version = "1.8.226";

  src = fetchFromGitHub {
    owner = "freescout-help-desk";
    repo = "freescout";
    tag = finalAttrs.version;
    hash = "sha256-9fojG6S6yb2+W94cHrLuYIRjRL8JWspsj4bNE4QKSuk=";
  };

  patches = [
    ./0001-settings-catch-unwritable-.env.patch
  ];

  prePatch = ''
    rm -rf storage
    rm bootstrap/cache/.gitignore
    rm public/{css,js}/builds/.htaccess
    rm {Modules,public/modules}/.gitkeep
    rmdir Modules public/modules bootstrap/cache public/{css,js}/builds
    ln -rs data/.env .env
    ln -rs data/storage storage
    ln -rs data/bootstrap/cache bootstrap/cache
    ln -rs data/storage/app/public public/storage
    ln -rs data/public/css/builds public/css/builds
    ln -rs data/public/js/builds public/js/builds
    ln -rs data/Modules Modules
    ln -rs data/public/modules public/modules
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/freescout
    cp -ar . $out/share/freescout
    chmod +x $out/share/freescout/artisan

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) freescout;
  };

  # Because freescout is searching for some folders only relative to it's own source location, we need to have the symlinks to the actual locations in here
  dontCheckForBrokenSymlinks = true;
  strictDeps = true;
  __structuredAttrs = true;

  meta = with lib; {
    description = "Free self-hosted help desk & shared mailbox";
    license = licenses.agpl3Only;
    homepage = "https://freescout.net/";
    platforms = platforms.all;
    maintainers = with maintainers; [ e1mo ];
  };
})
