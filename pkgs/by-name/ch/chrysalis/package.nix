{ lib, appimageTools, fetchurl }:

let
  pname = "chrysalis";
  version = "0.13.3";
  name = "${pname}-${version}-binary";
  src = fetchurl {
    url =
      "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}-x64.AppImage";
    hash =
      "sha512-F6Y87rgIclj1OA3gVX/gqqp9AvXKQlBXrbqk/26F1KHPF9NzHJgVmeszSo3Nhb6xg4CzWmzkqc8IW2H/Bg57kw==";
  };
  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
  inherit name pname src;

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
        --replace 'Exec=Chrysalis' 'Exec=${pname}'

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/256x256/chrysalis.png -t $out/share/pixmaps
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Graphical configurator for Kaleidoscope-powered keyboards";
    homepage = "https://github.com/keyboardio/Chrysalis";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aw eclairevoyant nshalman ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chrysalis";
  };
}
