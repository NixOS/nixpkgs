{
  lib,
  stdenv,
  fetchurl,
  undmg,
  appimageTools,
  makeWrapper,
}:

let

  pname = "sleek-todo";
  version = "2.0.28";

  suffixMap = {
    aarch64-darwin = "mac-arm64.dmg";
    aarch64-linux = "linux-arm64.AppImage";
    x86_64-linux = "linux-x86_64.AppImage";
  };

  suffix =
    suffixMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/ransome1/sleek/releases/download/v${version}/sleek-${version}-${suffix}";
    sha256 =
      {
        aarch64-darwin = "sha256-+xqn/Ffm5p4NbWmvrCp2ViG/CGtRRXcw0gE8Cs19N2Y=";
        aarch64-linux = "sha256-ujeXAJlB1sElk7bRlZ7dbTurKzD3IGRpHxsVNmUU5Ro=";
        x86_64-linux = "sha256-VzZwONKFl/7l6HXn387UfTllrU+x14X9vK6FN3buimU=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.system}");
  };

  meta = {
    description = "Todo manager based on todo.txt syntax";
    homepage = "https://github.com/ransome1/sleek";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "sleek-todo";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    sourceRoot = ".";
    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r *.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 (finalAttr: {
    inherit
      pname
      version
      src
      meta
      ;
    nativeBuildInputs = [ makeWrapper ];
    extraInstallCommands = ''
      wrapProgram $out/bin/sleek-todo \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      mkdir -p $out/share/{applications,sleek}
      cp -a ${finalAttr.contents}/{locales,resources} $out/share/sleek
      cp -a ${finalAttr.contents}/usr/share/icons $out/share
      install -Dm 444 ${finalAttr.contents}/sleek.desktop $out/share/applications
      substituteInPlace $out/share/applications/sleek.desktop \
      --replace-warn 'Exec=AppRun' 'Exec=${pname}'
    '';

  })
