{
  lib,
  apache-hop,
  fetchzip,
  bash,
  jre,
  maven,
  openjdk17,
  jdk ? openjdk17,
  unzip,
  swt,
  glib,
  testers,
  writeShellScript,
}:

let
  version = "2.14.0";
  swtPkg = swt.override { jdk = jdk; };
  hopDir = "$out/share/apache-hop";
  wrapHopTool = toolName: ''
    substitute "${wrapperTemplatePath}" "$out/bin/${toolName}" \
      --subst-var-by bash "${bash}/bin/bash" \
      --subst-var-by swtLibDir "${lib.getLib swtPkg}/lib" \
      --subst-var-by glibLibDir "${lib.getLib glib}/lib" \
      --subst-var-by version  "${version}" \
      --subst-var-by hopDir "${hopDir}" \
      --subst-var-by jre "${jre}" \
      --subst-var-by toolName "${toolName}" \
      --subst-var out
    chmod +x "$out/bin/${toolName}"
  '';
  wrapperTemplatePath = builtins.path {
    path = ./wrapper.sh;
    recursive = false;
  };
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
  inherit version;

  src = fetchzip {
    url = "https://www.apache.org/dyn/closer.cgi?filename=hop/${version}/apache-hop-${version}-src.tar.gz&action=download";
    hash = "sha256-PbzNydiaX6GXdShJjpPi8Bxh1USZzHi4Uul7w9uXaJg=";
  };

  mvnHash = "sha256-n/VabTh0/NvC4Yu8pH1XlF6/QwFPLCAGUfgp8nT+wo0=";
  mvnJdk = jdk;
  doCheck = false;

  nativeBuildInputs = [
    unzip
  ];
  buildInputs = [
    swtPkg
    glib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin ${hopDir}
    unzip assemblies/client/target/hop-client-${version}.zip -d ${hopDir}

    ${lib.concatMapStringsSep "\n" wrapHopTool hopTools}

    runHook postInstall
  '';

  passthru.tests =
    let
      with-home = writeShellScript "with-home" ''
        export HOME=$(mktemp -d)
        ${apache-hop}/bin/"$@" | grep -xv "The standard projects folder to browse to in the GUI is set to '$(HOME)/.config/apache-hop/config/projects'"
        # Exit code of «${apache-hop}/bin/"$@"» consciously ignored here,
        # because for some reason, it's 1 for the hop tools that support --version
        # when invoked with that option (or with its short form, -v)
      '';
    in
    {
      versionHopConf = testers.testVersion {
        package = apache-hop;
        command = "${with-home} hop-conf --version";
      };
      versionHopRun = testers.testVersion {
        package = apache-hop;
        command = "${with-home} hop-run --version";
      };
      versionHopImport = testers.testVersion {
        package = apache-hop;
        command = "${with-home} hop-import --version";
      };
      versionHopSearch = testers.testVersion {
        package = apache-hop;
        command = "${with-home} hop-search --version";
      };
    };

  meta = {
    description = "Data integration platform";
    homepage = "https://hop.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ das-g ];
  };
}
