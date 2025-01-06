{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  boost,
  libixion,
  mdds,
  python3,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "liborcus";
  version = "0.19.2";

  src = fetchFromGitLab {
    owner = "orcus";
    repo = "orcus";
    rev = version;
    hash = "sha256-+9C52H99c/kL5DEIoXV+WcLnTftRbicRLQN/FdIXBw8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    libixion
    mdds
    python3
    zlib
  ];

  meta = {
    description = "Collection of parsers and import filters for spreadsheet documents";
    homepage = "https://gitlab.com/orcus/orcus";
    changelog = "https://gitlab.com/orcus/orcus/-/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
