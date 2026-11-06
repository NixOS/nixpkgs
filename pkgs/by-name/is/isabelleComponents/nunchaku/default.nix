{ ocamlPackages, addSettings }:

addSettings ocamlPackages.nunchaku (finalAttrs: ''
  NUNCHAKU_HOME=${finalAttrs.finalPackage}/bin
  NUNCHAKU_VERSION=${finalAttrs.version}
'')
