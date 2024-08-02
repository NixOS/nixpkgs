{
  lib,
  stdenv,
  fetchFromGitHub,
  ldc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dlang-dfmt";
  version = "0.15.1-unstable-2024-05-12";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dfmt";
    rev = "0ea0572e86a270bb2d146e3609fbb72c624d32d0";
    hash = "sha256-/OXDFdXO4fC5xdZSPOAuB84jVW4I3Ap1fOcoUBxZzoQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ ldc ];

  buildFlags = [ "ldc" ];

  preBuild = ''
    mkdir bin
    echo ${finalAttrs.version} >bin/githash.txt
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = {
    description = "Formatter for D source code";
    homepage = "https://github.com/dlang-community/dfmt";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtbx ];
  };
})
