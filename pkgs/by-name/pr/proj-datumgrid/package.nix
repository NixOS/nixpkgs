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
    sha256 = "132wp77fszx33wann0fjkmi1isxvsb0v9iw0gd9sxapa9h6hf3am";
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
    homepage = "https://proj4.org";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nad2bin";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
