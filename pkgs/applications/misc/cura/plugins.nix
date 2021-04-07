{ lib, stdenv, fetchFromGitHub, fetchpatch, python3Packages, libspnav }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.18";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
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
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

    rawmouse = stdenv.mkDerivation rec {
      pname = "RawMouse";
      version = "1.0.13";

      src = fetchFromGitHub {
        owner = "smartavionics";
        repo = pname;
        rev = version;
        sha256 = "1cj40pgsfcwliz47mkiqjbslkwcm34qb1pajc2mcljgflcnickly";
      };

      buildPhase = ''
        substituteInPlace RawMouse/config.json --replace \
          /usr/local/lib/libspnav.so ${libspnav}/lib/libspnav.so
      '';

      installPhase = ''
        mkdir -p $out/lib/cura/plugins/RawMouse
        cp -rv . $out/lib/cura/plugins/RawMouse/
      '';

      meta = with lib; {
        description = "Cura plugin for HID mice such as 3Dconnexion spacemouse";
        homepage = "https://github.com/smartavionics/RawMouse";
        license = licenses.agpl3Plus;
        maintainers = with maintainers; [ gebner ];
      };
    };

  };

in self
