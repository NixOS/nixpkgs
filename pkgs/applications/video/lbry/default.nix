{ lib, fetchurl, appimageTools}:

let
  pname = "lbry-desktop";
  version = "0.52.4";
in appimageTools.wrapAppImage rec {
  name = "${pname}-${version}";

  # Fetch from GitHub Releases and extract
  src = appimageTools.extract {
    inherit name;
    src = fetchurl {
      url = "https://github.com/lbryio/lbry-desktop/releases/download/v${version}/LBRY_${version}.AppImage";
      # Gotten from latest-linux.yml
      sha512 = "TWRFCVktSKs5PORtm8FvM6qNWuiL/1HN98ilr1busVUGvain0QXGZwB/Dzvsox1c+X9VofUdapzozSOT6r58qw==";
    };
  };

  # At runtime, Lbry likes to have access to Ffmpeg
  extraPkgs = pkgs: with pkgs; [
    ffmpeg
  ];

  # General fixup
  extraInstallCommands = ''
    # Firstly, rename the executable to lbry for convinence
    mv $out/bin/${name} $out/bin/lbry

    # Now, install assets such as the desktop file and icons
    install -m 444 -D ${src}/lbry.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/lbry.desktop \
      --replace 'Exec=AppRun' 'Exec=lbry'
    cp -r ${src}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A browser and wallet for LBRY, the decentralized, user-controlled content marketplace";
    longDescription = ''
      The LBRY app is a graphical browser for the decentralized content marketplace provided by the LBRY protocol.
      It is essentially the lbry daemon bundled with a UI using Electron.
    '';
    license = licenses.mit;
    homepage = "https://lbry.com/";
    downloadPage = "https://lbry.com/get/";
    changelog = "https://github.com/lbryio/lbry-desktop/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ enderger ];
    platforms = [ "x86_64-linux" ];
  };
}
