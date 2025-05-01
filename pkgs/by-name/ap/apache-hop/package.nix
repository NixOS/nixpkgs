{
  lib,
  fetchzip,
  jre,
  makeWrapper,
  maven,
  openjdk17,
  jdk ? openjdk17,
  unzip,
  swt,
  glib,
}:

let
  swtPkg = swt.override { jdk = jdk; };
  swtLibDir = lib.getLib swtPkg + "/lib";
  glibLibDir = lib.getLib glib + "/lib";
  hopDir = "$out/share/apache-hop";
  wrapHopTool = toolName: ''
    makeWrapper ${hopDir}/hop/${toolName}.sh $out/bin/${toolName} \
      --set HOP_JAVA_HOME ${jre} \
      --run 'export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}${swtLibDir}:${glibLibDir}"' \
      --run 'export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"' \
      --run 'export HOP_AUDIT_FOLDER="$XDG_CONFIG_HOME/apache-hop/audit"' \
      --run 'export HOP_CONFIG_FOLDER="$XDG_CONFIG_HOME/apache-hop/config"' \
      --run 'mkdir -p "$(dirname "$HOP_CONFIG_FOLDER")"' \
      --run 'if [ ! -d "$HOP_CONFIG_FOLDER" ]; then cp -a --no-preserve=ownership ${hopDir}/hop/config/ "$HOP_CONFIG_FOLDER"; fi'
  '';
  hopTools = [
    "hop-conf"
    "hop-encrypt"
    "hop-gui"
    "hop-import"
    "hop-run"
    "hop-search"
    "hop-server"
  ];
in
maven.buildMavenPackage rec {
  pname = "apache-hop";
  version = "2.12.0";

  src = fetchzip {
    url = "https://www.apache.org/dyn/closer.cgi?filename=hop/${version}/apache-hop-${version}-src.tar.gz&action=download";
    hash = "sha256-lpibF8evbSpiMdDO3v6+XIJUzU1v6ZuyZjc2ja2lJwg=";
  };

  mvnHash = "sha256-Ih7BaU8cKDCGLDGCxuGV75yv0tc/9HPVqLIh+JYM/PY=";
  mvnJdk = jdk;
  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  buildInputs = [
    swtPkg
    glib
  ];

  installPhase = ''
    mkdir -p $out/bin ${hopDir}
    unzip assemblies/client/target/hop-client-${version}.zip -d ${hopDir}

    ${lib.concatMapStringsSep "\n" wrapHopTool hopTools}
  '';

  meta = {
    description = "A data integration platform";
    homepage = "https://hop.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ das-g ];
  };
}
