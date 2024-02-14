{ lib
, stdenvNoCC
, fetchFromGitLab
, cmake
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

  #nativeBuildInputs = [ cmake ];

  buildInputs = [ alglib ];

  installPhase = ''
    runHook preinstall
    mkdir -p $out/{bin,usr/share/rainbowcrack}
    cp -R *.txt rt* rcrack $out/usr/share/rainbowcrack
    cp -R debian/helper-script/* $out/bin
    chmod 755 $out/usr/share/rainbowcrack/rcrack
    find $out{bin,/usr/share/rainbowcrack} -name "r*" -exec chmod 755 {} \;
    sed -i 's/\/usr/result\/usr/g' $out/bin/*
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
