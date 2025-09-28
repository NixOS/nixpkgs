{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  libspnav,
  jq,
}:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.18";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = "Cura-OctoPrintPlugin";
        rev = "7bd73946fbf22d18337dc900a81a011ece26bee0";
        sha256 = "057b2f5f49p96lkh2wsr9w6yh2003x4a85irqsgbzp6igmk8imdn";
      };

      propagatedBuildInputs = with python3Packages; [
        netifaces
      ];

      installPhase = ''
        mkdir -p $out/lib/cura/plugins/OctoPrintPlugin
        cp -rv . $out/lib/cura/plugins/OctoPrintPlugin/
      '';

      meta = with lib; {
        description = "Enables printing directly to OctoPrint and monitoring the process";
        homepage = "https://github.com/fieldOfView/Cura-OctoPrintPlugin";
        license = licenses.agpl3Plus;
        maintainers = with maintainers; [ ];
      };
    };

    rawmouse = stdenv.mkDerivation rec {
      pname = "RawMouse";
      version = "1.1.0";

      src = fetchFromGitHub {
        owner = "smartavionics";
        repo = "RawMouse";
        rev = version;
        sha256 = "0hvi7qwd4xfnqnhbj9dgfjmvv9df7s42asf3fdfxv43n6nx74scw";
      };

      nativeBuildInputs = [ jq ];

      propagatedBuildInputs = with python3Packages; [
        hidapi
      ];

      buildPhase = ''
        jq 'del(.devices) | .libspnav="${libspnav}/lib/libspnav.so"' \
          <RawMouse/config.json >RawMouse/config.json.new
        mv RawMouse/config.json.new RawMouse/config.json

        # remove prebuilt binaries
        rm -r RawMouse/hidapi
      '';

      installPhase = ''
        mkdir -p $out/lib/cura/plugins/RawMouse
        cp -rv . $out/lib/cura/plugins/RawMouse/
      '';

      meta = with lib; {
        description = "Cura plugin for HID mice such as 3Dconnexion spacemouse";
        homepage = "https://github.com/smartavionics/RawMouse";
        license = licenses.agpl3Plus;
        maintainers = with maintainers; [ ];
      };
    };

  };

in
self
