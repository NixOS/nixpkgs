{ lib, appimageTools, fetchurl }:

let
  pname = "chrysalis";
<<<<<<< HEAD
  version = "0.13.2";
  name = "${pname}-${version}-binary";
  src = fetchurl {
    url =
      "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}-x64.AppImage";
    hash =
      "sha512-WuItdQ/hDxbZZ3zulHI74NUkuYfesV/31rA1gPakCFgX2hpPrmKzwUez2vqt4N5qrGyphrR0bcelUatGZhOn5A==";
  };
  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 rec {
  inherit name pname src;

  multiArch = false;
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.glib ];
=======
  version = "0.12.0";
in appimageTools.wrapAppImage rec {
  name = "${pname}-${version}-binary";

  src = appimageTools.extract {
    inherit name;
    src = fetchurl {
      url = "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
      sha256 = "sha256-sQoEO1UII4Gbp7UbHCCyejsd94lkBbi93TH325EamFc=";
    };
  };

  multiPkgs = null;
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
    p.glib
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Also expose the udev rules here, so it can be used as:
  #   services.udev.packages = [ pkgs.chrysalis ];
  # to allow non-root modifications to the keyboards.

  extraInstallCommands = ''
<<<<<<< HEAD
    mv $out/bin/{${name},${pname}}

    install -m 444 \
      -D ${appimageContents}/usr/lib/chrysalis/resources/static/udev/60-kaleidoscope.rules \
      -t $out/lib/udev/rules.d

    install -m 444 \
        -D ${appimageContents}/Chrysalis.desktop \
        -t $out/share/applications
    substituteInPlace \
        $out/share/applications/Chrysalis.desktop \
        --replace 'Exec=Chrysalis' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share
=======
    mv $out/bin/${name} $out/bin/${pname}

    mkdir -p $out/lib/udev/rules.d
    ln -s \
      --target-directory=$out/lib/udev/rules.d \
      ${src}/resources/static/udev/60-kaleidoscope.rules
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A graphical configurator for Kaleidoscope-powered keyboards";
    homepage = "https://github.com/keyboardio/Chrysalis";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aw ];
    platforms = [ "x86_64-linux" ];
<<<<<<< HEAD
    mainProgram = pname;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
