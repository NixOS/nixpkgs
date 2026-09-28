{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  boost188,
  mdds,
  python3,
}:
let
  boost = boost188;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libixion";
  version = "0.20.0";

  src = fetchFromGitLab {
    owner = "ixion";
    repo = "ixion";
    rev = finalAttrs.version;
    hash = "sha256-v72ihA/V21zM2xHe8t5MKYag1RUC9bWGpq7Sr7x+YIw=";
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

  meta = {
    description = "General purpose formula parser, interpreter, formula cell dependency tracker and spreadsheet document model backend all in one package";
    homepage = "https://gitlab.com/ixion/ixion";
    changelog = "https://gitlab.com/ixion/ixion/-/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
