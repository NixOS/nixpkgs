{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrub";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "chaos";
    repo = "scrub";
    rev = finalAttrs.version;
    hash = "sha256-LokAr4zDwRO9D2P0/1S8vZHmpTrArOB31xT/1kTMrFk=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ libtool ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "Disk overwrite utility";
    homepage = "https://github.com/chaos/scrub";
    changelog = "https://raw.githubusercontent.com/chaos/scrub/master/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    platforms = lib.platforms.unix;
    mainProgram = "scrub";
  };
})
