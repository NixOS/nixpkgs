{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  coin-utils,
  zlib,
  osi,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.17.11";
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-Gt42F6xc1XgcB6VvtaSAam8/QLJjPRHNKkx3sBFwcFg=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    zlib
    coin-utils
    osi
  ];

  doCheck = true;

  meta = {
    license = lib.licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "Open-source linear programming solver written in C++";
    mainProgram = "clp";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
