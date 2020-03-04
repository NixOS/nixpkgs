{ stdenv, fetchFromGitHub, fetchpatch, cmake, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.11";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "3cef0a955ae7ccfa5c07d20d9d147c530cc9d6ec";
        sha256 = "0q9bkwgpsbfwkp1bfaxq3wm9pbwx5d7ji0jr7cwc4y5nizji81is";
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
