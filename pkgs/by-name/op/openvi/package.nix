{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  perl,
  apple-sdk_11,
}:

stdenv.mkDerivation rec {
  pname = "openvi";
  version = "7.6.30";

  src = fetchFromGitHub {
    owner = "johnsonjh";
    repo = "OpenVi";
    rev = version;
    hash = "sha256-P4w/PM9UmHmTzS9+WDK3x3MyZ7OoY2yO/Rx0vRMJuLI=";
  };

  buildInputs = [
    ncurses
    perl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  makeFlags = [
    "PREFIX=$(out)"
    # command -p will yield command not found error
    "PAWK=awk"
    # silently fail the chown command
    "IUSGR=$(USER)"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/johnsonjh/OpenVi";
    description = "Portable OpenBSD vi for UNIX systems";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "ovi";
  };
}
