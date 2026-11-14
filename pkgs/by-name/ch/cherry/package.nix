{
  lib,
  stdenv,
  fetchFromGitHub,
  mkfontscale,
  fonttosfnt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cherry";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "turquoise-hexagon";
    repo = "cherry";
    tag = finalAttrs.version;
    hash = "sha256-BpXYl21sX1ptL5/NociMGliQmeY7FdLJ7myabC7v848=";
  };

  nativeBuildInputs = [
    fonttosfnt
    mkfontscale
  ];

  buildPhase = ''
    patchShebangs make.sh
    ./make.sh
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp *.otb $out/share/fonts/misc

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir $out/share/fonts/misc
  '';

  meta = {
    description = "cherry font";
    homepage = "https://github.com/turquoise-hexagon/cherry";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
