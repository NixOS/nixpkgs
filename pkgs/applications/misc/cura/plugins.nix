{ stdenv, fetchFromGitHub, cmake, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.8";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "46548cbb8d32d10fe3aee12f272d5d8f34271738";
        sha256 = "0pllba8qx1746pnf5ccbkqn2j6f8hhknpgyrrv244ykvigrlczx0";
      };

      nativeBuildInputs = [ cmake ];

      propagatedBuildInputs = with python3Packages; [
        netifaces
      ];

      meta = with stdenv.lib; {
        description = "Enables printing directly to OctoPrint and monitoring the process";
        homepage = "https://github.com/fieldOfView/Cura-OctoPrintPlugin";
        license = licenses.agpl3;
        maintainers = with maintainers; [ gebner ];
      };
    };

  };

in self
