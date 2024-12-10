{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "idsk";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "cpcsdk";
    repo = "idsk";
    rev = "v${version}";
    hash = "sha256-rYClWq1Nl3COoG+eOJyFDTvBSzpHpGminU4bndZs6xc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/cpcsdk/idsk/commit/52fa3cdcc10d4ba6c75cab10ca7067b129198d92.patch";
      hash = "sha256-Ll0apllNj+fP7kZ1n+bBowrlskLK1bIashxxgPVVxmg=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 iDSK $out/bin/iDSK

    runHook postInstall
  '';

  meta = with lib; {
    description = "Manipulating CPC dsk images and files";
    homepage = "https://github.com/cpcsdk/idsk";
    license = licenses.mit;
    mainProgram = "iDSK";
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
}
