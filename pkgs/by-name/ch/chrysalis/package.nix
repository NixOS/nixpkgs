{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "chrysalis";
  version = "0.13.3";
  src = fetchurl {
    url = "https://github.com/keyboardio/chrysalis/releases/download/v${version}/chrysalis-${version}-x64.AppImage";
    hash = "sha512-F6Y87rgIclj1OA3gVX/gqqp9AvXKQlBXrbqk/26F1KHPF9NzHJgVmeszSo3Nhb6xg4CzWmzkqc8IW2H/Bg57kw==";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.glib ];

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.chrysalis ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
    install -m 444 \
      -D ${appimageContents}/usr/lib/chrysalis/resources/static/udev/60-kaleidoscope.rules \
      -t $out/lib/udev/rules.d

    install -m 444 \
        -D ${appimageContents}/Chrysalis.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/Chrysalis.desktop \
        --replace-fail 'Exec=Chrysalis' 'Exec=${pname}'

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/256x256/chrysalis.png -t $out/share/pixmaps
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Graphical configurator for Kaleidoscope-powered keyboards";
    homepage = "https://github.com/keyboardio/Chrysalis";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      aw
      nshalman
    ];
    platforms = [ "x86_64-linux" ];
    # buildFHSEnv will create a symlink in $out/bin/${pname}
    mainProgram = pname;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
