{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  git,
}:

let
  pname = "rebased";
  version = "1.1.5";

  src = fetchurl {
    url =
      {
        x86_64-linux = "https://github.com/DetachHead/rebased/releases/download/${version}/Rebased-x86_64.AppImage";
        aarch64-linux = "https://github.com/DetachHead/rebased/releases/download/${version}/Rebased-aarch64.AppImage";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash =
      {
        x86_64-linux = "sha256-AJumwyhrt0kD+TrG5uFFSymJt+YupXhoEtjIRNlYzuc=";
        aarch64-linux = "sha256-G4YT1SCzRM5cjuT2RH4o1UL1Jv4AMT0iqqjyHrSuknA=";
      }
      .${stdenv.hostPlatform.system};
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "rebased";
    exec = "rebased %U";
    icon = "rebased";
    desktopName = "Rebased";
    comment = "A git client based on the IntelliJ platform";
    categories = [
      "Development"
      "IDE"
    ];
    startupWMClass = "jetbrains-rebased";
    startupNotify = true;
  };
in
(appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    git
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/usr/bin/idea.svg \
      $out/share/icons/hicolor/scalable/apps/rebased.svg
    install -Dm444 ${desktopItem}/share/applications/*.desktop \
      -t $out/share/applications
  '';

  meta = {
    description = "Git client based on the IntelliJ platform";
    homepage = "https://github.com/DetachHead/rebased";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "rebased";
    maintainers = with lib.maintainers; [ Oops418 ];
  };
}).overrideAttrs
  (_: {
    strictDeps = true;
    __structuredAttrs = true;
  })
