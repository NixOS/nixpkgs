{
  buildNpmPackage,
  fetchzip,
  lib,
}:
buildNpmPackage (finalAttrs: {
  pname = "ionic-cli";
  version = "7.2.1";

  src = fetchzip {
    url = "https://registry.npmjs.org/@ionic/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-nrZMMyzoiO7ZJbNrPSRA1sOEy3OpgEXdyNS0JzAaTjY=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-Nu4AWwFaGBakGAxUNllx4etUm4H5ygxAeMs1RWhzRQQ=";

  dontNpmBuild = true;

  meta = {
    description = "Your go-to tool for developing Ionic apps";
    homepage = "https://ionicframework.com/";
    license = lib.licenses.mit;
    mainProgram = "ionic";
    maintainers = with lib.maintainers; [
      albertlarsan68
    ];
  };
})
