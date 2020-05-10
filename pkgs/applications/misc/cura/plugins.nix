{ stdenv, fetchFromGitHub, fetchpatch, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.12";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "ad522c0b7ead5fbe28da686a3cc75e351274c2bc";
        sha256 = "0ln11ng32bh0smfsk54mv2j3sadh0gwf031nmm95zrvbj9cr6yc0";
      };

      propagatedBuildInputs = with python3Packages; [
        netifaces
      ];

      installPhase = ''
        mkdir -p $out/lib/cura/plugins/OctoPrintPlugin
        cp -rv . $out/lib/cura/plugins/OctoPrintPlugin/
      '';

      meta = with stdenv.lib; {
        description = "Enables printing directly to OctoPrint and monitoring the process";
        homepage = "https://github.com/fieldOfView/Cura-OctoPrintPlugin";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

  };

in self
