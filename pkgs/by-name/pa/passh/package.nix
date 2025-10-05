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
    sha256 = "1g0rx94vqg36kp46f8v4x6jcmvdk85ds6bkrpayq772hbdm1b5z5";
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
