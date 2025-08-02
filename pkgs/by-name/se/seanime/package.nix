{
  stdenvNoCC,
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  google-fonts,
}:
let
  pname = "seanime";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${version}";
    hash = "sha256-SgKWr2AtTbY1/TmLIQXKWh+mDnLndWB6v59Gq3vD+2A=";
  };

  seanime-web = buildNpmPackage {
    pname = "seanime-web";

    inherit version src;

    npmDepsHash = "sha256-wwRQpr+czJ225RReGLy/EqLa9Hqn6VlLDmI78U09HiE=";

    sourceRoot = "${src.name}/seanime-web";

    dontNpmBuild = true;

    postPatch = ''
      mkdir -p src/

      cp "${
        google-fonts.override { fonts = [ "Inter" ]; }
      }/share/fonts/truetype/Inter[opsz,wght].ttf" src/app/Inter.ttf

      substituteInPlace ./src/app/layout.tsx \
        --replace-quiet 'import { Inter } from "next/font/google"' 'import localFont from "next/font/local"' \
        --replace-quiet 'const inter = Inter({ subsets: ["latin"] })' 'const inter = localFont({ src: "./Inter.ttf" })'
    '';

    buildPhase = ''
      runHook preBuild

      npm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/web

      cp -r out/* $out/web

      runHook postInstall
    '';
  };

  seanime-server = buildGoModule {
    pname = "seanime-server";

    inherit src version;

    vendorHash = "sha256-TeEPAzVb8g5ONSKvsfe9IVHf9sri9xqqsR+yYFW9wc4=";

    preBuild = ''
      mkdir web

      cp -R ${seanime-web}/web/** web/

      #  .github scripts redeclare main
      rm -rf .github
    '';

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
    ];
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -Dm775 ${seanime-server}/bin/seanime $out/bin/seanime

    runHook postInstall
  '';

  passthru = {
    web = seanime-web;
    server = seanime-server;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "web"
      "--subpackage"
      "server"
    ];
  };

  meta = {
    description = "Open-source media server with a web interface and desktop app for anime and manga";
    homepage = "https://github.com/5rahim/seanime";
    changelog = "https://github.com/5rahim/seanime/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    platforms = lib.platforms.linux;
    mainProgram = "seanime";
  };
}
