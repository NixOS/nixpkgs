{ trivialBuild
, lib
, fetchFromGitHub
, curl
, plz
, cl-lib
, ts
}:

trivialBuild {
  pname = "ement";
  version = "unstable-2021-09-16";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "c07e914f077199c95b0e7941a421675c95d4687e";
    sha256 = "sha256-kYVb2NrHYC87mY/hFUMAjb4TLJ9A2L2RrHoiAXvRaGg=";
  };

  packageRequires = [
    plz
    cl-lib
    ts
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
