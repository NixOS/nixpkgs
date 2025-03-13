{
  lib,
  gccStdenv,
  fetchFromGitHub,
}:

gccStdenv.mkDerivation {
  pname = "pnut";
  version = "0-unstable-2024-10-20";

  src = fetchFromGitHub {
    owner = "udem-dlteam";
    repo = "pnut";
    rev = "f30d6fda77339ae57f480c0086660a01fde003f6";
    hash = "sha256-UQ+6MbTrxMgL5h2kK19X5wxhFQ3FSBvtCWA/RQw8CvU=";
  };

  doCheck = false; # test suite missing cc.sh and not failing on error

  installPhase = ''
    runHook preInstall

    install -Dm755 build/pnut-sh $out/bin/pnut

    runHook postInstall
  '';

  meta = {
    description = "C compiler written in POSIX shell and generating POSIX shell scripts";
    homepage = "https://pnut.sh";
    license = lib.licenses.bsd2;
    mainProgram = "pnut";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
