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

stdenv.mkDerivation (finalAttrs: {
  pname = "liborcus";
  version = "0.21.0";

  src = fetchFromGitLab {
    owner = "orcus";
    repo = "orcus";
    rev = finalAttrs.version;
    hash = "sha256-vR/TtfUOa2Fmc4APfqG+Xu+mTAILGV+/JJnnmNHNJdQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3.pythonOnBuildForHost
  ];

  buildInputs = [
    boost
    libixion
    mdds
    python3
    zlib
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  preCheck = ''
    patchShebangs test/python
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}${
      lib.concatMapStringsSep ":" (d: "$(pwd)/src/${d}/.libs") [
        "liborcus"
        "parser"
        "python"
        "spreadsheet"
      ]
    }
  '';

  strictDeps = true;
  doCheck = true;
  enableParallelBuilding = true;
  enableParallelChecking = true;

  meta = {
    description = "Collection of parsers and import filters for spreadsheet documents";
    homepage = "https://gitlab.com/orcus/orcus";
    changelog = "https://gitlab.com/orcus/orcus/-/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
