{ pkgs, addSettings }:

addSettings pkgs.postgresql_jdbc (finalAttrs: ''
  classpath "${finalAttrs.finalPackage}/share/java/postgresql-jdbc.jar"
'')
