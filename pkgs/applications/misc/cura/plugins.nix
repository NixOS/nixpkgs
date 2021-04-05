{ lib, stdenv, fetchFromGitHub, fetchpatch, python3Packages }:

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

  };

in self
