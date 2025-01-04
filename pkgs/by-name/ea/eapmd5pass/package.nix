{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl_1_1,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "eapmd5pass";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "joswr1ght";
    repo = "eapmd5pass";
    rev = "v${version}";
    hash = "sha256-DYoily2dX/mbDFpQivGZZ/JMTIblooMzeoMw19w1Ky4=";
  };

  buildInputs = [
    openssl_1_1
    libpcap
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp eapmd5pass $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Brute force password selection for EAP-MD5 authentication exchanges";
    homepage = "https://github.com/joswr1ght/eapmd5pass";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "eapmd5pass";
    platforms = platforms.all;
  };
}
