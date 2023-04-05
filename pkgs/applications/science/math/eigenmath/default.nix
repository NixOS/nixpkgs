{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "eigenmath";
  version = "unstable-2023-03-05";

  src = fetchFromGitHub {
    owner = "georgeweigt";
    repo = pname;
    rev = "633d5b0b2f2b87b6377bc4f715604f79b17aab66";
    hash = "sha256-5LOSyfeGavWesAR7jqd37Z845iyNstr/cJdQiWHlIPg=";
  };

  patches = [
    # treewide: use $(CC) instead of hardcoding gcc
    # https://github.com/georgeweigt/eigenmath/pull/18
    (fetchpatch {
      url = "https://github.com/georgeweigt/eigenmath/commit/70551b3624ea25911f6de608c9ee9833885ab0b8.patch";
      hash = "sha256-g2crXOlC5SM1vAq87Vg/2zWMvx9DPFWEPaTrrPbcDZ0=";
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 eigenmath "$out/bin/eigenmath"
    runHook postInstall
  '';

  meta = with lib;{
    description = "Computer algebra system written in C";
    homepage = "https://georgeweigt.github.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nickcao ];
  };
}
