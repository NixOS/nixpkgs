{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "pfsshell";

  src = fetchFromGitHub {
    owner = "uyjulian";
    repo = "pfsshell";
    rev = "v${version}";
    sha256 = "0cr91al3knsbfim75rzl7rxdsglcc144x0nizn7q4jx5cad3zbn8";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Build errors since 1.1.1 when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "PFS (PlayStation File System) shell for POSIX-based systems";
    platforms = platforms.unix;
    license = with licenses; [
      gpl2Only # the pfsshell software itself
      afl20 # APA, PFS, and iomanX libraries which are compiled together with this package
    ];
    maintainers = with maintainers; [ makefu ];
    mainProgram = "pfsshell";
  };
}
