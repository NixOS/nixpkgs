{
  lib,
  stdenv,
  fetchurl,
  mysql_jdbc,
  extensions ? { },
  libJars ? [ ],
  nixosTests,
  mysqlSupport ? true,
}:
let
  inherit (lib)
    concatStringsSep
    licenses
    maintainers
    mapAttrsToList
    optionalString
    forEach
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apache-druid";
  version = "34.0.0";

  src = fetchurl {
    url = "mirror://apache/druid/${finalAttrs.version}/apache-druid-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-y5Sx8mubb+XEqPxlhPL67od1kVck2M+IkvQP/CyrZpA=";
  };

  dontBuild = true;

  loadExtensions = (
    concatStringsSep "\n" (
      mapAttrsToList (
        dir: files:
        ''
          if ! test -d $out/extensions/${dir}; then
               mkdir $out/extensions/${dir};
           fi
        ''
        + concatStringsSep "\n" (
          forEach files (file: ''
            if test -d ${file} ; then
              cp  ${file}/* $out/extensions/${dir}/
            else
              cp ${file} $out/extensions/${dir}/
            fi
          '')
        )
      ) extensions
    )
  );

  loadJars = concatStringsSep "\n" (forEach libJars (jar: "cp ${jar} $out/lib/"));

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out
    ${optionalString mysqlSupport "ln -s ${mysql_jdbc}/share/java/mysql-connector-j.jar $out/extensions/mysql-metadata-storage"}
    ${finalAttrs.loadExtensions}
    ${finalAttrs.loadJars}
    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.druid.default.passthru.override { druidPackage = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Apache Druid: a high performance real-time analytics database";
    homepage = "https://github.com/apache/druid";
    license = licenses.asl20;
    maintainers = with maintainers; [ vsharathchandra ];
    mainProgram = "druid";
  };

})
