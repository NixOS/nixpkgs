{ eprover-ho, addSettings }:

addSettings eprover-ho (finalAttrs: ''
  E_HOME=${finalAttrs.finalPackage}/bin
  E_VERSION=${finalAttrs.version}
'')
