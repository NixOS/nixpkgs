{
  lib,
  gccStdenv,
  fetchFromGitHub,
}:

gccStdenv.mkDerivation {
  pname = "pnut";
  version = "0-unstable-2024-07-24";

  src = fetchFromGitHub {
    owner = "udem-dlteam";
    repo = "pnut";
    rev = "1bc6a0d68de9e2284ddc2d9af889584cc6360616";
    hash = "sha256-+13iTSK15i+9jt+BMmCygeCw8AQ5rDvhcLh/rP/qaY8=";
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
