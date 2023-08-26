{ stdenvNoCC
, lib
, mmdoc
, nixos-doc-src
}:

stdenvNoCC.mkDerivation rec {
  name = "nixos-minimal-manual";

  src = lib.fileset.toSource rec {
    root = nixos-doc-src;
    fileset = lib.fileset.fileFilter
      (file: file.hasExt "md" || file.hasExt "dot")
      nixos-doc-src;
  };

  dontUnpack = true;

  buildCommand = ''
    cp -r $src doc
    chmod -R u+w doc
    cp ${./toc.md} doc/toc.md
    ${mmdoc}/bin/mmdoc nixos doc $out
  '';

  meta = with lib; {
    description = "NixOS minimal manual";
    homepage = "https://github.com/nixos/nixpkgs";
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
