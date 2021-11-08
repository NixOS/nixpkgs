{ lib, fetchurl, appimageTools, imagemagick, systemd }:

let
  pname = "ledger-live-desktop";
  version = "2.34.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    sha256 = "00zl7ywmkbhwzkj7p618rin5pd0ix8cas5q1b8ka6ynw4wlg3w5c";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  # Hotplug events from udevd are fired into the kernel, which then re-broadcasts them over a
  # special socket, to every libudev client listening for hotplug when the kernel does that. It will
  # try to preserve the uid of the sender but a non-root namespace (like the fhs-env) cant map root
  # to a uid, for security reasons, so the uid of the sender becomes nobody and libudev actively
  # rejects such messages. This patch disables that bit of security in libudev.
  # See: https://github.com/NixOS/nixpkgs/issues/116361
  systemdPatched = systemd.overrideAttrs ({ patches ? [ ], ... }: {
    patches = patches ++ [ ./systemd.patch ];
  });
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraPkgs = pkgs: [ systemdPatched ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/ledger-live-desktop.desktop $out/share/applications/ledger-live-desktop.desktop
    install -m 444 -D ${appimageContents}/ledger-live-desktop.png $out/share/icons/hicolor/1024x1024/apps/ledger-live-desktop.png
    ${imagemagick}/bin/convert ${appimageContents}/ledger-live-desktop.png -resize 512x512 ledger-live-desktop_512.png
    install -m 444 -D ledger-live-desktop_512.png $out/share/icons/hicolor/512x512/apps/ledger-live-desktop.png
    substituteInPlace $out/share/applications/ledger-live-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Wallet app for Ledger Nano S and Ledger Blue";
    homepage = "https://www.ledger.com/live";
    license = licenses.mit;
    maintainers = with maintainers; [ andresilva thedavidmeister nyanloutre RaghavSood th0rgal ];
    platforms = [ "x86_64-linux" ];
  };
}
