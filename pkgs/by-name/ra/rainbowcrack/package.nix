{ lib
, stdenvNoCC
, fetchFromGitLab
, alglib
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

  buildInputs = [ alglib ];

  installPhase = ''
    runHook preinstall
    mkdir -p $out/{bin,usr/share/rainbowcrack}
    cp -R *.txt rt* rcrack $out/usr/share/rainbowcrack
    cp -R rt* rcrack $out/bin
    chmod +x $out/bin/r*
    runHook postinstall
  '';

  meta = with lib; {
    description = "Rainbow table generator to be used for cracking password";
    homepage = "https://gitlab.com/kalilinux/packages/rainbowcrack";
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "rcrack";
    platforms = platforms.all;
  };
}
