{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
}:

let
  pname = "gitsquid";
  version = "2.13.5";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/TheMax98000/gitsquid-releases/releases/download/v${version}/GitSquid_${version}_amd64.AppImage";
      hash = "sha256-EicW1jTGCo1Azrh8OIw/vVwC79BNujomN5+ypk7uG9A=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/TheMax98000/gitsquid-releases/releases/download/v${version}/GitSquid_${version}_aarch64.AppImage";
      hash = "sha256-I3kR8Mc4AWCcxn4ftN0OZxoAOonOsarudYq3wtNrdmk=";
    };
  };

  appimageSrc =
    srcs.${stdenv.hostPlatform.system}
      or (throw "gitsquid: unsupported system ${stdenv.hostPlatform.system}");

  src = appimageTools.extract {
    inherit pname version;
    src = appimageSrc;

    # The AppImage bundles Wayland libraries from its build environment. These
    # are incompatible with newer host Mesa versions and cause WebKitGTK to
    # abort with EGL_BAD_PARAMETER, leaving an empty window.
    postExtract = ''
      rm $out/usr/lib/libwayland-*.so*
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${src}/usr/share/applications/GitSquid.desktop \
      $out/share/applications/GitSquid.desktop
    cp -r ${src}/usr/share/icons $out/share/
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform graphical client for Git";
    homepage = "https://gitsquid.dev/";
    downloadPage = "https://github.com/TheMax98000/gitsquid-releases/releases";
    changelog = "https://github.com/TheMax98000/gitsquid-releases/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ TurnrDev ];
    platforms = builtins.attrNames srcs;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "gitsquid";
  };
}
