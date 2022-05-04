{ trivialBuild
, lib
, fetchFromGitHub
, curl
, plz
, cl-lib
, ts
, magit-section
, taxy-magit-section
, taxy
, svg-lib
}:

trivialBuild {
  pname = "ement";
  version = "unstable-2022-04-22";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "70da19e4c9210d362b1d6d9c17ab2c034a03250d";
    sha256 = "sha256-Pxul0WrtyH2XZzF0fOOitLc3x/kc+Qc11RDH0n+Hm04=";
  };

  packageRequires = [
    plz
    cl-lib
    ts
    magit-section
    taxy-magit-section
    taxy
    svg-lib
  ];

  patches = [
    ./handle-nil-images.patch
  ];

  meta = {
    description = "Ement.el is a Matrix client for Emacs";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
