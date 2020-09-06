{ stdenv, fetchFromGitHub, fetchpatch, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.16";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "8affa8aa9796cb37129d3b7222fff03f86c936cd";
        sha256 = "0l4qfcashkdmpdm8nm3klz6hmi1f0bmbpb9b1yn4mvg0fam6c5xi";
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
