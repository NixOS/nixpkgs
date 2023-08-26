{ stdenvNoCC
, lib
, mmdoc
, nixpkgs-manual-lib-docs
, nixpkgs-doc-src
}:

stdenvNoCC.mkDerivation rec {
  name = "nixpkgs-minimal-manual";

  src = lib.fileset.toSource rec {
    root = nixpkgs-doc-src;
    fileset = lib.fileset.fileFilter
      (file: file.hasExt "md" || file.hasExt "dot")
      nixpkgs-doc-src;
  };

  dontUnpack = true;

  buildCommand = ''
    cp -r $src doc
    chmod -R u+w doc
    cp ${./toc.md} doc/toc.md
    mkdir -p doc/functions/library/
    cp ${nixpkgs-manual-lib-docs}/*.md doc/functions/library/
    ${mmdoc}/bin/mmdoc nixpkgs doc $out
  '';

  meta = with lib; {
    description = "Nixpkgs minimal manual";
    homepage = "https://github.com/nixos/nixpkgs";
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
