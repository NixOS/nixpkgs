{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
}:

stdenv.mkDerivation {
  pname = "hb-honeypot";
  version = "0-unstable-2024-02-13";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "hb-honeypot";
    rev = "06ca7336bfb7deca54eae2cee239496d26f21b5b";
    hash = "sha256-vnq7u/sqDLD+PsZ9DlxfjNuTkO8lhZujjAgmTcWf/3I=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/hb-honeypot}
    cp hb-honeypot.pl $out/share/hb-honeypot/
    makeWrapper ${perl}/bin/perl $out/bin/hb-honeypot \
      --add-flags "$out/share/hb-honeypot/hb-honeypot.pl"
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Script that listens on TCP port 443 and responds with completely bogus SSL heartbeat responses";
    mainProgram = "hb-honeypot";
    homepage = "https://github.com/D3vil0p3r/hb-honeypot";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "Script that listens on TCP port 443 and responds with completely bogus SSL heartbeat responses";
    mainProgram = "hb-honeypot";
    homepage = "https://github.com/D3vil0p3r/hb-honeypot";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
