{ stdenv, fetchFromGitHub, cmake, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.5";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "d05a9a4c1a01c584d5cec4f4b7d170077235467a";
        sha256 = "0ik69g3kbn7rz2wh0cfq9ww8x222kagd8jvsd4xlqgq4yrf0jk7x";
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
