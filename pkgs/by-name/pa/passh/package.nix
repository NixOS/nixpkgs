{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "passh";
  version = "2020-03-18";

  src = fetchFromGitHub {
    owner = "clarkwang";
    repo = "passh";
    rev = "7112e667fc9e65f41c384f89ff6938d23e86826c";
    hash = "sha256-5ZcValtQnIO9unkuo1tBs+3KpOlkI2fInWY8vEnqGbw=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 passh $out/bin/passh
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/clarkwang/passh";
    description = "Sshpass alternative for non-interactive ssh auth";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.lovesegfault ];
    mainProgram = "passh";
    platforms = lib.platforms.unix;
  };
}
