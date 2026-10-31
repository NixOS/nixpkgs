{
  openjdk21,
  stdenv,
  addSettings,
}:

addSettings openjdk21 (finalAttrs: ''
  ISABELLE_JAVA_PLATFORM=${stdenv.hostPlatform.system}
  ISABELLE_JDK_HOME=${finalAttrs.finalPackage}
'')
