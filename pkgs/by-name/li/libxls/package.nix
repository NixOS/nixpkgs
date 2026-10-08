{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxls";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "libxls";
    repo = "libxls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KbITHQ9s2RUeo8zR53R9s4WUM6z8zzddz1k47So0Mlw=";
  };

  # workaround required to build against gettext >= 0.25
  # https://savannah.gnu.org/support/index.php?111272
  preAutoreconf = ''
    autopoint --force
  '';

  # workaround required to build against gettext >= 0.25
  # https://savannah.gnu.org/support/index.php?111273
  autoreconfFlags = [
    "--include=m4"
    "--install"
    "--force"
    "--verbose"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Extract Cell Data From Excel xls files";
    changelog = "https://github.com/libxls/libxls/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/libxls/libxls";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "xls2csv";
    platforms = lib.platforms.unix;
  };
})
