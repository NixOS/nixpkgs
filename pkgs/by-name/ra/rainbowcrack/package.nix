{ lib
, stdenvNoCC
, fetchFromGitLab
}:

stdenvNoCC.mkDerivation rec {
  pname = "rainbowcrack";
  version = "1.8-0kali1";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "rainbowcrack";
    rev = "kali/${version}";
    hash = "sha256-y6jdFVQSO80YLLOitPAY8TVMUsi58B6+3bFoncwr+Qo=";
  };

  installPhase = ''
    runHook preinstall
    mkdir -p $out/bin
    cp -r * $out/bin
    runHook postinstall
  '';

  meta = with lib; {
    description = "Rainbow table generator to be used for cracking password";
    homepage = "https://gitlab.com/kalilinux/packages/rainbowcrack";
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "rainbowcrack";
    platforms = platforms.all;
  };
}
