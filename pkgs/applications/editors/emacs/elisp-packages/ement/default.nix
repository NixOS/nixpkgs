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
  version = "unstable-2022-05-14";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "961d650377f9e7440e47c36c0386e899f5b2d86b";
    sha256 = "sha256-4KTSPgso7UvzCRKNFI3YaPR1t4DUwggO4KtBYLm0W4Y=";
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
