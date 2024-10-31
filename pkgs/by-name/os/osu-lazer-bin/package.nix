{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  appimageTools,
  makeWrapper,
}:

let
  pname = "osu-lazer-bin";
  version = "2024.1009.1";

  src =
    {
      aarch64-darwin = fetchzip {
        url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Apple.Silicon.zip";
        hash = "sha256-fH7cuk879nS8FDIZ8p29pg2aXLJUT+j6Emb39Y6FXq4=";
        stripRoot = false;
      };
      x86_64-darwin = fetchzip {
        url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Intel.zip";
        hash = "sha256-kIH+zlNaqMVbr8FVDiLUh19gfrFUDPGBvMOrZqkMZAE=";
        stripRoot = false;
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
        hash = "sha256-2H2SPcUm/H/0D9BqBiTFvaCwd0c14/r+oWhyeZdNpoU=";
      };
    }
    .${stdenv.system} or (throw "osu-lazer-bin: ${stdenv.system} is unsupported.");

  meta = {
    description = "Rhythm is just a *click* away (AppImage version for score submission and multiplayer, and binary distribution for Darwin systems)";
    homepage = "https://osu.ppy.sh";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      gepbird
      stepbrobd
    ];
    mainProgram = "osu!";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };

  passthru.updateScript = ./update.sh;
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    installPhase = ''
      runHook preInstall
      APP_DIR="$out/Applications"
      mkdir -p "$APP_DIR"
      cp -r . "$APP_DIR"
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    extraPkgs = pkgs: with pkgs; [ icu ];

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        . ${makeWrapper}/nix-support/setup-hook
        mv -v $out/bin/${pname} $out/bin/osu!
        wrapProgram $out/bin/osu! \
          --set OSU_EXTERNAL_UPDATE_PROVIDER 1
        install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu!.png $out/share/icons/hicolor/''${i}x$i/apps/osu!.png
        done
      '';
  }
