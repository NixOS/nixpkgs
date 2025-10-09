{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  unzip,
  jdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlcl";
  version = "25.2.2.199.0918";

  src = fetchurl {
    url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-${finalAttrs.version}.zip";
    hash = "sha256-YsIEJkQXeVIABsCXNBfT6WZbrXur1hoEZFj97JvGHV8=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p $out/libexec
    mv * $out/libexec/

    makeWrapper $out/libexec/bin/sql $out/bin/sqlcl \
      --set JAVA_HOME ${jdk.home} \
      --chdir "$out/libexec/bin"
  '';

  meta = with lib; {
    description = "Oracle's Oracle DB CLI client";
    longDescription = ''
      Oracle SQL Developer Command Line (SQLcl) is a free command line
      interface for Oracle Database. It allows you to interactively or batch
      execute SQL and PL/SQL. SQLcl provides in-line editing, statement
      completion, and command recall for a feature-rich experience, all while
      also supporting your previously written SQL*Plus scripts.
    '';
    homepage = "https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ misterio77 ];
  };
})
