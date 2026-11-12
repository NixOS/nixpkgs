{
  lib,
  stdenv,
  fetchFromGitHub,
  tcl,
  tclPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqawk";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "sqawk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ES7P9m/meudN3RKd3DgFMuaTChyMwus7cKEYxasi/3w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    tcl
    tcl.tclPackageHook
  ];

  buildInputs = [
    tclPackages.tcllib
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Like awk, but with SQL and table joins";
    homepage = "https://github.com/dbohdan/sqawk/";
    license = lib.licenses.mit;
    mainProgram = "sqawk";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
