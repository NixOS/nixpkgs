{
  lib,
  graphicsmagick,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "graphicsmagick-imagemagick-compat";
  inherit (graphicsmagick) version;

  outputs = [
    "out"
    "man"
  ];

  dontUnpack = true;
  dontBuild = true;

  # TODO: symlink libraries?
  installPhase =
    let
      utilities = [
        "animate"
        "composite"
        "conjure"
        "convert"
        "display"
        "identify"
        "import"
        "mogrify"
        "montage"
      ];
      linkUtilityBin = utility: ''
        ln -s ${lib.getExe graphicsmagick} "$out/bin/${utility}"
      '';
      linkUtilityMan = utility: ''
        ln -s ${lib.getMan graphicsmagick}/share/man/man1/gm.1.gz "$man/share/man/man1/${utility}.1.gz"
      '';
    in
    ''
      runHook preInstall

      mkdir -p "$out"/bin
      ${lib.concatStringsSep "\n" (map linkUtilityBin utilities)}
      mkdir -p "$man"/share/man/man1
      ${lib.concatStringsSep "\n" (map linkUtilityMan utilities)}

      runHook postInstall
    '';

  meta = graphicsmagick.meta // {
    description = "Repack of GraphicsMagick that provides compatibility with ImageMagick interfaces";
  };
}
