{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  appimageTools,
  makeWrapper,
  nativeWayland ? false,
}:

let
  pname = "osu-lazer-bin";
  version = "2025.1029.1";

  src =
    {
      aarch64-darwin = fetchzip {
        url = "https://github.com/ppy/osu/releases/download/${version}-lazer/osu.app.Apple.Silicon.zip";
        hash = "sha256-Asqz0jiiHTtLcBzvibNzlaRe0jAop5YU4gmooZf/8gw=";
        stripRoot = false;
      };
      x86_64-darwin = fetchzip {
        url = "https://github.com/ppy/osu/releases/download/${version}-lazer/osu.app.Intel.zip";
        hash = "sha256-2ZAZ3CnYz/6VJxqpDNvx6jGcNV/9oo8Eb5/GkSidiv0=";
        stripRoot = false;
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/ppy/osu/releases/download/${version}-lazer/osu.AppImage";
        hash = "sha256-lx+RN20sPiG++pLS0gW6ixIYw3+g1KGCMrAhgW+yZIw=";
      };
    }
    .${stdenvNoCC.system} or (throw "osu-lazer-bin: ${stdenvNoCC.system} is unsupported.");

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
      Guanran928
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
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall
      OSU_WRAPPER="$out/Applications/osu!.app/Contents"
      OSU_CONTENTS="osu!.app/Contents"
      mkdir -p "$OSU_WRAPPER/MacOS"
      cp -r "$OSU_CONTENTS/Info.plist" "$OSU_CONTENTS/Resources" "$OSU_WRAPPER"
      cp -r "osu!.app" "$OSU_WRAPPER/Resources/osu-wrapped.app"
      makeWrapper "$OSU_WRAPPER/Resources/osu-wrapped.app/Contents/MacOS/osu!" "$OSU_WRAPPER/MacOS/osu!" --set OSU_EXTERNAL_UPDATE_PROVIDER 1
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

    # fix OpenGL renderer on nvidia + wayland
    extraBwrapArgs = [
      "--ro-bind-try /etc/egl/egl_external_platform.d /etc/egl/egl_external_platform.d"
    ];

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        . ${makeWrapper}/nix-support/setup-hook
        mv -v $out/bin/${pname} $out/bin/osu!

        wrapProgram $out/bin/osu! \
          ${lib.optionalString nativeWayland "--set SDL_VIDEODRIVER wayland"} \
          --set OSU_EXTERNAL_UPDATE_PROVIDER 1

        install -m 444 -D ${contents}/osu!.desktop -t $out/share/applications
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu.png $out/share/icons/hicolor/''${i}x$i/apps/osu.png
        done
      '';
  }
