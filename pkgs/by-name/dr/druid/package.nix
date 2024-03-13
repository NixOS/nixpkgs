{ lib
, stdenv
, fetchurl
, makeWrapper
, extensions ? { }
, libJars ? [ ]
, nixosTests
, mysqlSupport ? true
}:
let
  inherit (lib) concatStringsSep mapAttrsToList optionalString forEach;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "apache-druid";
  version = "29.0.0";
  src = fetchurl {
    url = "mirror://apache/druid/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-bin.tar.gz";
    sha256 = "sha256-Ka/coMWYXDjP18hgwwJq+xzSO7tL7/XtIZRcekpX6g4=";
  };
  mysqlConnector = fetchurl {
    url = "https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.48/mysql-connector-java-5.1.48.jar";
    hash = "sha256:1a7cnr4r03mv7j0d6sji07m892ygcr7wgya4mzj5l7w2lfm6rqjn";
  };
  dontBuild = true;
  loadExtensions = (concatStringsSep "\n"
    (mapAttrsToList
      (dir: files:
        ''
          if ! test -d $out/extensions/${dir}; then
               mkdir $out/extensions/${dir};
           fi
        ''
        +
        concatStringsSep "\n"
          (forEach files
            (file: ''
              if test -d ${file} ; then
                cp  ${file}/* $out/extensions/${dir}/
              else
                cp ${file} $out/extensions/${dir}/
              fi
            ''
            )
          )
      )
      extensions
    )
  );
  loadJars = concatStringsSep "\n" (
    forEach libJars
      (
        jar: "cp ${jar} $out/lib/"
      )
  );
  installPhase = ''
    mkdir -p $out
    mv * $out
    ${optionalString mysqlSupport "cp ${finalAttrs.mysqlConnector} $out/extensions/mysql-metadata-storage"}
    ${finalAttrs.loadExtensions}
    ${finalAttrs.loadJars}
  '';

})
