{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proj-datumgrid";
  version = "world-1.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "proj-datumgrid";
    rev = finalAttrs.version;
    hash = "sha256-VQ0HDUzqqq5Te4DHtMHSu+sYYp3SAWsVH6N/7c65XIw=";
  };

  sourceRoot = "${finalAttrs.src.name}/scripts";

  buildPhase = ''
    $CC nad2bin.c -o nad2bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nad2bin $out/bin/
  '';

  meta = {
    description = "Repository for proj datum grids";
    homepage = "https://proj.org";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nad2bin";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
