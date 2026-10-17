{ ocamlPackages, addSettings }:

addSettings ocamlPackages.smbc (finalAttrs: ''
  SMBC_HOME="${finalAttrs.finalPackage}/bin"
  SMBC_VERSION="${finalAttrs.version}";
'')
