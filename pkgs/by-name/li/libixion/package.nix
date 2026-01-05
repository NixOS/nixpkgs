{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  boost,
  mdds,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libixion";
  version = "0.19.0";

  src = fetchFromGitLab {
    owner = "ixion";
    repo = "ixion";
    rev = version;
    hash = "sha256-BrexWRaxrLTWuoU62kqws3tlSqVOHecSV5MXc4ZezFs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3.pythonOnBuildForHost
  ];

  buildInputs = [
    boost
    mdds
    python3
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  meta = with lib; {
    description = "General purpose formula parser, interpreter, formula cell dependency tracker and spreadsheet document model backend all in one package";
    homepage = "https://gitlab.com/ixion/ixion";
    changelog = "https://gitlab.com/ixion/ixion/-/blob/${src.rev}/CHANGELOG";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
