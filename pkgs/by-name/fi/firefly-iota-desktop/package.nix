{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "firefly-iota-desktop";
  version = "2.0.12";
  src = fetchurl {
    url = "https://github.com/iotaledger/firefly/releases/download/desktop-iota-${version}/firefly-iota-desktop-${version}.AppImage";
    hash = "sha256-V+RbrEcZWmbHurNhme1EufYHtECX93wXhlgJNG1E4tU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -D -m 444 ${appimageContents}/desktop.desktop $out/share/applications/firefly-iota-desktop.desktop
    install -D -m 444 ${appimageContents}/desktop.png $out/share/pixmaps/firefly-iota-desktop.png
    substituteInPlace $out/share/applications/firefly-iota-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=firefly-iota-desktop' \
      --replace-fail 'Icon=desktop' 'Icon=firefly-iota-desktop'
  '';

  meta = {
    description = "Firefly IOTA Wallet";
    homepage = "https://firefly.iota.org";
    changelog = "https://github.com/iotaledger/firefly/releases/tag/desktop-iota-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mfcrizz ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "firefly-iota-desktop";
  };
}
