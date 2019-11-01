{ stdenv, fetchFromGitHub, fetchpatch, cmake, python3Packages }:

let

  self = {

    octoprint = stdenv.mkDerivation rec {
      pname = "Cura-OctoPrintPlugin";
      version = "3.5.8";

      src = fetchFromGitHub {
        owner = "fieldOfView";
        repo = pname;
        rev = "0702f3a52887ea4ab6736c990bbe9628d677688e";
        sha256 = "0cm4kciw3izqk51pfbznawk80k7n7pyvrlzd9ccjgdl994ljcqi5";
      };

      nativeBuildInputs = [ cmake ];

      propagatedBuildInputs = with python3Packages; [
        netifaces
      ];

      patches = [
        # Fix incorrect paths in CMakeLists.txt
        # https://github.com/fieldOfView/Cura-OctoPrintPlugin/pull/131
        (fetchpatch {
          url = "https://github.com/gebner/Cura-OctoPrintPlugin/commit/fce8c21b3a584559da7942cb239fbf6673153454.patch";
          sha256 = "06d82jpqvcpz90svhhlk2g3pvxm3psfnd2j30m6cl9441qp5nvcp";
        })
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
