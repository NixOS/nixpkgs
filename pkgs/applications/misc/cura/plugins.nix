{ stdenv, fetchFromGitHub, fetchpatch, cmake, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.8";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "a82a42a87bbeb390b80b991afb1a6741c46a3432";
        sha256 = "0q5yd7pw626qls2ks2y39hb9czd6lgh71jalzl2drwdi6a8mwsfz";
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
