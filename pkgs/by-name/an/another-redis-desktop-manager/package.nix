{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
  libxshmfence,
}:
let
  pname = "another-redis-desktop-manager";
  version = "1.7.1";
  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-linux-${version}-x86_64.AppImage";
          hash = "sha256-XuS4jsbhUproYUE2tncT43R6ErYB9WTg6d7s16OOxFQ=";
        };
        aarch64-linux = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-linux-${version}-arm64.AppImage";
          hash = "sha256-0WXWl0UAQBqJlvt2MNpNHuqmEAlIlvY0FfHXu4LKkcY=";
        };
        x86_64-darwin = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-mac-${version}-x64.dmg";
          hash = "sha256-UqwzgxBSZR0itCknKzBClEX3w9aFKFhGIiVUQNYDVEM=";
        };
        aarch64-darwin = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-mac-${version}-arm64.dmg";
          hash = "sha256-LjmZCauxwk+WP80L9i5JOr12s212fX+p4xveZgCPM7w=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.system}");
  meta = {
    description = "A faster, better and more stable redis desktop manager";
    longDescription = ''
      Faster, better, more stable Redis Desktop (GUI) management client, compatible with Windows, Mac, Linux, superior performance, easy to load massive key values.
      Supports Sentinel, clustering, ssh channels, ssl authentication, stream, subscribe, tree view, command line, and dark mode; A variety of formatting methods, and even the ability to customize formatting scripts,
    '';
    homepage = "https://github.com/qishibo/AnotherRedisDesktopManager";
    changelog = "https://github.com/qishibo/AnotherRedisDesktopManager?tab=readme-ov-file#feature-log";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      joyanhui
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "another-redis-desktop-manager";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;
    nativeBuildInputs = [ undmg ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r *.app $out/Applications/
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
      ;
    extraPkgs = pkgs: [
      libxshmfence
    ];
    extraInstallCommands = ''
      mkdir -p $out/share/${pname}
      cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
      cp -a ${appimageContents}/usr/share/icons $out/share/
      install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  }
