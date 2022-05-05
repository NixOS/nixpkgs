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
  version = "unstable-2022-05-05";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "84739451afa8355360966dfa788d469d9dc4a8e3";
    sha256 = "sha256-XdegBKZfoKbFaMM/l8249VD9KKC5/4gQIK6ggPcoOaE=";
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
