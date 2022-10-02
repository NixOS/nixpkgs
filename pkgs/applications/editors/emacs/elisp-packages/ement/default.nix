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
  version = "unstable-2022-09-01";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "4ec2107e6a90ed962ddd3875d47caa523eb466b9";
    sha256 = "sha256-zKkBpaOj3qb/Oy89rt7BxmWZDZzDzMIJjjOm+1rrnnc=";
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
