{
  lib,
  stdenv,
  libbsd,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.2";
  pname = "metastore";

  src = fetchFromGitHub {
    owner = "przemoc";
    repo = "metastore";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+0dufZvsOc8uHw/Co4/kcTS71GO2CLxAfJjryRwHYVU=";
  };

  buildInputs = [ libbsd ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Store and restore metadata from a filesystem";
    mainProgram = "metastore";
    homepage = "https://software.przemoc.net/#metastore";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sstef ];
    platforms = lib.platforms.linux;
  };
})
