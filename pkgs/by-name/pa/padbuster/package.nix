{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "padbuster";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "AonCyberLabs";
    repo = pname;
    rev = "50e4a3e2bf5dfff5699440b3ebc61ed1b5c49bbe";
    sha256 = "VIvZ28MVnTSQru6l8flLVVqIIpxxXD8lCqzH81sPe/U=";
  };

  buildInputs = [
    (perl.withPackages (
      ps: with ps; [
        LWP
        LWPProtocolHttps
        CryptSSLeay
      ]
    ))
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 padBuster.pl $out/bin/padBuster.pl

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automated script for performing Padding Oracle attacks";
    homepage = "https://www.gdssecurity.com/l/t.php";
    mainProgram = "padBuster.pl";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
