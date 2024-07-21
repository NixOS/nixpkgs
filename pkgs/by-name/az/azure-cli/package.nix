{
  lib,
  callPackage,
  callPackages,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  runCommand,
  installShellFiles,
  python311,
  writeScriptBin,

  # Whether to include patches that enable placing certain behavior-defining
  # configuration files in the Nix store.
  withImmutableConfig ? true,

  # List of extensions/plugins to include.
  withExtensions ? [ ],

  azure-cli,
}:

let
  version = "2.62.0";

  src = fetchFromGitHub {
    name = "azure-cli-${version}-src";
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-${version}";
    hash = "sha256-Rb27KRAb50YzTZzMs6n8g04x14ni3rIYAL3c5j/ieRw=";
  };

  # Pin Python version to 3.11.
  # See https://discourse.nixos.org/t/breaking-changes-announcement-for-unstable/17574/53
  # and https://github.com/Azure/azure-cli/issues/27673
  python3 = python311;

  # put packages that needs to be overridden in the py package scope
  py = callPackage ./python-packages.nix { inherit src version python3; };

  # Builder for Azure CLI extensions. Extensions are Python wheels that
  # outside of nix would be fetched by the CLI itself from various sources.
  mkAzExtension =
    {
      pname,
      version,
      url,
      sha256,
      description,
      ...
    }@args:
    python3.pkgs.buildPythonPackage (
      {
        format = "wheel";
        src = fetchurl { inherit url sha256; };
        meta = {
          inherit description;
          inherit (azure-cli.meta) platforms maintainers;
          homepage = "https://github.com/Azure/azure-cli-extensions";
          changelog = "https://github.com/Azure/azure-cli-extensions/blob/main/src/${pname}/HISTORY.rst";
          license = lib.licenses.mit;
          sourceProvenance = [ lib.sourceTypes.fromSource ];
        } // args.meta or { };
      }
      // (removeAttrs args [
        "url"
        "sha256"
        "description"
        "meta"
      ])
    );

  extensions =
    callPackages ./extensions-generated.nix { inherit mkAzExtension; }
    // callPackages ./extensions-manual.nix {
      inherit mkAzExtension python3;
      python3Packages = python3.pkgs;
    };

  extensionDir = stdenvNoCC.mkDerivation {
    name = "azure-cli-extensions";
    dontUnpack = true;
    installPhase =
      let
        namePaths = map (p: "${p.pname},${p}/${python3.sitePackages}") withExtensions;
      in
      ''
        for line in ${lib.concatStringsSep " " namePaths}; do
          name=$(echo $line | cut -d',' -f1)
          path=$(echo $line | cut -d',' -f2)
          mkdir -p $out/$name
          for f in $(ls $path); do
            ln -s $path/$f $out/$name/$f
          done
        done
      '';
  };
in

py.pkgs.toPythonApplication (
  py.pkgs.buildAzureCliPackage rec {
    pname = "azure-cli";
    inherit version src;

    sourceRoot = "${src.name}/src/azure-cli";

    nativeBuildInputs = [ installShellFiles ];

    # Dependencies from:
    # https://github.com/Azure/azure-cli/blob/azure-cli-2.62.0/src/azure-cli/setup.py#L52
    # Please, keep ordered by upstream file order. It facilitates reviews.
    propagatedBuildInputs =
      with py.pkgs;
      [
        antlr4-python3-runtime
        azure-appconfiguration
        azure-batch
        azure-cli-core
        azure-cosmos
        azure-data-tables
        azure-datalake-store
        azure-graphrbac
        azure-keyvault-administration
        azure-keyvault-certificates
        azure-keyvault-keys
        azure-keyvault-secrets
        azure-mgmt-advisor
        azure-mgmt-apimanagement
        azure-mgmt-appconfiguration
        azure-mgmt-appcontainers
        azure-mgmt-applicationinsights
        azure-mgmt-authorization
        azure-mgmt-batchai
        azure-mgmt-batch
        azure-mgmt-billing
        azure-mgmt-botservice
        azure-mgmt-cdn
        azure-mgmt-cognitiveservices
        azure-mgmt-compute
        azure-mgmt-containerinstance
        azure-mgmt-containerregistry
        azure-mgmt-containerservice
        azure-mgmt-cosmosdb
        azure-mgmt-databoxedge
        azure-mgmt-datamigration
        azure-mgmt-devtestlabs
        azure-mgmt-dns
        azure-mgmt-eventgrid
        azure-mgmt-eventhub
        azure-mgmt-extendedlocation
        azure-mgmt-hdinsight
        azure-mgmt-imagebuilder
        azure-mgmt-iotcentral
        azure-mgmt-iothub
        azure-mgmt-iothubprovisioningservices
        azure-mgmt-keyvault
        azure-mgmt-kusto
        azure-mgmt-loganalytics
        azure-mgmt-managedservices
        azure-mgmt-managementgroups
        azure-mgmt-maps
        azure-mgmt-marketplaceordering
        azure-mgmt-media
        azure-mgmt-monitor
        azure-mgmt-msi
        azure-mgmt-netapp
        azure-mgmt-policyinsights
        azure-mgmt-privatedns
        azure-mgmt-rdbms
        azure-mgmt-recoveryservicesbackup
        azure-mgmt-recoveryservices
        azure-mgmt-redis
        azure-mgmt-redhatopenshift
        azure-mgmt-resource
        azure-mgmt-search
        azure-mgmt-security
        azure-mgmt-servicebus
        azure-mgmt-servicefabricmanagedclusters
        azure-mgmt-servicelinker
        azure-mgmt-servicefabric
        azure-mgmt-signalr
        azure-mgmt-sqlvirtualmachine
        azure-mgmt-sql
        azure-mgmt-storage
        azure-mgmt-synapse
        azure-mgmt-trafficmanager
        azure-mgmt-web
        azure-monitor-query
        azure-multiapi-storage
        azure-storage-common
        azure-synapse-accesscontrol
        azure-synapse-artifacts
        azure-synapse-managedprivateendpoints
        azure-synapse-spark
        chardet
        colorama
      ]
      ++ lib.optional stdenv.isLinux distro
      ++ [
        fabric
        javaproperties
        jsondiff
        packaging
        pycomposefile
        pygithub
        pynacl
        scp
        semver
        six
        sshtunnel
        tabulate
        urllib3
        websocket-client
        xmltodict

        # Other dependencies
        pyopenssl # Used at: https://github.com/Azure/azure-cli/blob/azure-cli-2.62.0/src/azure-cli/azure/cli/command_modules/servicefabric/custom.py#L11
        setuptools # ModuleNotFoundError: No module named 'pkg_resources'
      ]
      ++ lib.optionals (!withImmutableConfig) [
        # pip is required to install extensions locally, but it's not needed if
        # we're using the default immutable configuration.
        pip
      ]
      ++ lib.concatMap (extension: extension.propagatedBuildInputs) withExtensions;

    postInstall =
      ''
        substituteInPlace az.completion.sh \
          --replace register-python-argcomplete ${py.pkgs.argcomplete}/bin/register-python-argcomplete
        installShellCompletion --bash --name az.bash az.completion.sh
        installShellCompletion --zsh --name _az az.completion.sh
      ''
      + lib.optionalString withImmutableConfig ''
        export HOME=$TMPDIR
        $out/bin/az --version
        mkdir -p $out/etc/azure
        mv $TMPDIR/.azure/commandIndex.json $out/etc/azure/commandIndex.json
        mv $TMPDIR/.azure/versionCheck.json $out/etc/azure/versionCheck.json
      ''
      + ''
        # remove garbage
        rm $out/bin/az.bat
        rm $out/bin/az.completion.sh
      '';

    # wrap the executable so that the python packages are available
    # it's just a shebang script which calls `python -m azure.cli "$@"`
    postFixup =
      ''
        wrapProgram $out/bin/az \
      ''
      + lib.optionalString withImmutableConfig ''
        --set AZURE_IMMUTABLE_DIR $out/etc/azure \
      ''
      + lib.optionalString (withExtensions != [ ]) ''
        --set AZURE_EXTENSION_DIR ${extensionDir} \
      ''
      + ''
        --set PYTHONPATH "${python3.pkgs.makePythonPath propagatedBuildInputs}:$out/${python3.sitePackages}"
      '';

    doInstallCheck = true;
    installCheckPhase = ''
      export HOME=$TMPDIR

      $out/bin/az --version
      $out/bin/az self-test
    '';

    # ensure these namespaces are able to be accessed
    pythonImportsCheck = [
      "azure.batch"
      "azure.cli.core"
      "azure.cli.telemetry"
      "azure.cosmos"
      "azure.datalake.store"
      "azure.graphrbac"
      "azure.keyvault"
      "azure.mgmt.advisor"
      "azure.mgmt.apimanagement"
      "azure.mgmt.applicationinsights"
      "azure.mgmt.appconfiguration"
      "azure.mgmt.appcontainers"
      "azure.mgmt.authorization"
      "azure.mgmt.batch"
      "azure.mgmt.batchai"
      "azure.mgmt.billing"
      "azure.mgmt.botservice"
      "azure.mgmt.cdn"
      "azure.mgmt.cognitiveservices"
      "azure.mgmt.compute"
      "azure.mgmt.containerinstance"
      "azure.mgmt.containerregistry"
      "azure.mgmt.containerservice"
      "azure.mgmt.cosmosdb"
      "azure.mgmt.datamigration"
      "azure.mgmt.devtestlabs"
      "azure.mgmt.dns"
      "azure.mgmt.eventgrid"
      "azure.mgmt.eventhub"
      "azure.mgmt.hdinsight"
      "azure.mgmt.imagebuilder"
      "azure.mgmt.iotcentral"
      "azure.mgmt.iothub"
      "azure.mgmt.iothubprovisioningservices"
      "azure.mgmt.keyvault"
      "azure.mgmt.kusto"
      "azure.mgmt.loganalytics"
      "azure.mgmt.managedservices"
      "azure.mgmt.managementgroups"
      "azure.mgmt.maps"
      "azure.mgmt.marketplaceordering"
      "azure.mgmt.media"
      "azure.mgmt.monitor"
      "azure.mgmt.msi"
      "azure.mgmt.netapp"
      "azure.mgmt.policyinsights"
      "azure.mgmt.privatedns"
      "azure.mgmt.rdbms"
      "azure.mgmt.recoveryservices"
      "azure.mgmt.recoveryservicesbackup"
      "azure.mgmt.redis"
      "azure.mgmt.resource"
      "azure.mgmt.search"
      "azure.mgmt.security"
      "azure.mgmt.servicebus"
      "azure.mgmt.servicefabric"
      "azure.mgmt.signalr"
      "azure.mgmt.sql"
      "azure.mgmt.sqlvirtualmachine"
      "azure.mgmt.storage"
      "azure.mgmt.trafficmanager"
      "azure.mgmt.web"
      "azure.monitor.query"
      "azure.storage.common"
    ];

    passthru = {
      inherit extensions;
      withExtensions = extensions: azure-cli.override { withExtensions = extensions; };
      tests = {
        # Test the package builds with some extensions configured, and the
        # wanted extensions are recognized by the CLI and listed in the output.
        azWithExtensions =
          let
            extensions = with azure-cli.extensions; [
              aks-preview
              azure-devops
              rdbms-connect
            ];
            extensionNames = map (ext: ext.pname) extensions;
            az = (azure-cli.withExtensions extensions);
          in
          runCommand "test-az-with-extensions" { } ''
            export HOME=$TMPDIR
            ${lib.getExe az} extension list > $out
            for ext in ${lib.concatStringsSep " " extensionNames}; do
              if ! grep -q $ext $out; then
                echo "Extension $ext not found in list"
                exit 1
              fi
            done
          '';
        # Test the package builds with mutable config.
        # TODO: Maybe we can install an extension from local python wheel to
        #       check mutable extension install still works.
        azWithMutableConfig =
          let
            az = azure-cli.override { withImmutableConfig = false; };
          in
          runCommand "test-az-with-immutable-config" { } ''
            export HOME=$TMPDIR
            ${lib.getExe az} --version || exit 1
            touch $out
          '';
      };

      generate-extensions = writeScriptBin "${pname}-update-extensions" ''
        export FILE=extensions-generated.nix
        echo "# This file is automatically generated. DO NOT EDIT! Read README.md" > $FILE
        echo "{ mkAzExtension }:" >> $FILE
        echo "{" >> $FILE
        ${./query-extension-index.sh} --requirements=false --download --nix --cli-version=${version} \
          | xargs -n1 -d '\n' echo " " >> $FILE
        echo "" >> $FILE
        echo "}" >> $FILE
        echo "Extension was saved to \"extensions-generated.nix\" file."
        echo "Move it to \"{nixpkgs}/pkgs/by-name/az/azure-cli/extensions-generated.nix\"."
      '';
    };

    meta = {
      homepage = "https://github.com/Azure/azure-cli";
      description = "Next generation multi-platform command line experience for Azure";
      downloadPage = "https://github.com/Azure/azure-cli/releases/tag/azure-cli-${version}";
      longDescription = ''
        The Azure Command-Line Interface (CLI) is a cross-platform
        command-line tool to connect to Azure and execute administrative
        commands on Azure resources. It allows the execution of commands
        through a terminal using interactive command-line prompts or a script.

        `azure-cli` has extension support. For example, to install the `aks-preview` extension, use

        ```nix
        environment.systemPackages = [
          (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
        ];
        ```

        To make the `azure-cli` immutable and prevent clashes in case `azure-cli` is also installed via other package managers,
        some configuration files were moved into the derivation. This can be disabled by overriding `withImmutableConfig = false`
        when building `azure-cli`.
      '';
      changelog = "https://github.com/MicrosoftDocs/azure-docs-cli/blob/main/docs-ref-conceptual/release-notes-azure-cli.md";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      license = lib.licenses.mit;
      mainProgram = "az";
      maintainers = with lib.maintainers; [ katexochen ] ++ lib.teams.stridtech.members;
      platforms = lib.platforms.all;
    };
  }
)
