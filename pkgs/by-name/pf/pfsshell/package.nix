{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.1";
  pname = "pfsshell";

  src = fetchFromGitHub {
    owner = "uyjulian";
    repo = "pfsshell";
    rev = "v${finalAttrs.version}";
    sha256 = "0cr91al3knsbfim75rzl7rxdsglcc144x0nizn7q4jx5cad3zbn8";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Build errors since 1.1.1 when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "PFS (PlayStation File System) shell for POSIX-based systems";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      gpl2Only # the pfsshell software itself
      afl20 # APA, PFS, and iomanX libraries which are compiled together with this package
    ];
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "pfsshell";
  };
})
