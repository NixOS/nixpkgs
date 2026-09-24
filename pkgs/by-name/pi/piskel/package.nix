{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeDesktopItem,
  makeWrapper,

  nwjs,
}:

let
  desktopItem = makeDesktopItem {
    desktopName = "Piskel";
    comment = "Easy-to-use sprite editor";
    name = "piskel";
    exec = "piskel";
    icon = "piskel";
    terminal = false;
    categories = [ "Graphics" ];
  };
in
buildNpmPackage rec {
  pname = "piskel";
  # Newest version is 0.15.0 and is years old already (also doesn't build correctly)
  version = "0.15.2-SNAPSHOT-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "piskelapp";
    repo = "piskel";
    rev = "a6b9c02daefceb10093f71e92d52d16920ccb16e";
    hash = "sha256-AorkV1mqZJ9coRMRCCdYIdAwhedrBRG8GR7Y0/zPPHo=";
  };
  npmDepsHash = "sha256-tu0A5Xcz2V12pRF0LxHA48czkPR/0SslA3SEGdhdqMQ=";

  env = {
    "PUPPETEER_SKIP_DOWNLOAD" = "1";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/site/dest/

    cp -r dest/prod $out/site/dest/
    cp package.json $out/site/

    install -Dm644 ${desktopItem}/share/applications/piskel.desktop -t $out/share/applications
    install -Dm644 src/logo.png $out/share/icons/hicolor/64x64/apps/piskel.png

    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} \
      --add-flags $out/site

    runHook postInstall
  '';

  meta = {
    description = "Easy-to-use sprite editor";
    homepage = "https://github.com/piskelapp/piskel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rsahwe
    ];
    mainProgram = "piskel";
    platforms = nwjs.meta.platforms;
  };

  __structuredAttrs = true;
}
