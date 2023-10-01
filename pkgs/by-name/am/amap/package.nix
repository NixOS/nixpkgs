{ lib
, stdenv
, pkgs
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "amap";
  version = "5.4-4kali3";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "amap";
    rev = "kali/${version}";
    hash = "sha256-lLx9oeSgGpDl3FfKxaVQzZoEwrCPrBHM6MGIKAD5h4U=";
  };

  configurePhase = ''
    ./configure --prefix=$out
  '';

  nativeBuildInputs = with pkgs; [
    autoconf
    automake
  ];

  buildInputs = with pkgs; [
    libuecc
  ];

  meta = with lib; {
    description = "A next generation scanning tool";
    homepage = "https://gitlab.com/kalilinux/packages/amap";
    changelog = "https://gitlab.com/packages/amap/-/blob/${src.rev}/CHANGES";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "amap";
  };
}
