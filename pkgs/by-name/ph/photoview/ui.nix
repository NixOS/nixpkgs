{
  src,
  version,
  lib,
  buildNpmPackage,
}:

buildNpmPackage {
  pname = "photoview-ui";
  inherit version;

  src = "${src}/ui";

  npmDepsHash = "sha256-wUbfq+7SuJUBxfy9TxHVda8A0g4mmYCbzJT64XBN2mI=";

  NODE_ENV = "production";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/* $out/
    runHook postInstall
  '';

  meta = {
    description = "Web UI for Photoview photo gallery";
    homepage = "https://photoview.github.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nettika ];
    platforms = lib.platforms.all;
  };
}
