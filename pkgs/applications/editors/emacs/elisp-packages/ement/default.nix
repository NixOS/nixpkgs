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
  version = "unstable-2021-10-08";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "c951737dc855604aba389166bb0e7366afadc533";
    sha256 = "00iwwz4hzg4g59wrb5df6snqz3ppvrsadhfp61w1pa8gvg2z9bvy";
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
