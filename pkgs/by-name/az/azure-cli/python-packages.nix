{
  stdenv,
  python3,
  fetchPypi,
  src,
  version,
}:

let
  buildAzureCliPackage = with py.pkgs; buildPythonPackage;

  overrideAzureMgmtPackage =
    package: version: extension: hash:
    package.overridePythonAttrs (oldAttrs: {
      inherit version;

      src = fetchPypi {
        inherit (oldAttrs) pname;
        inherit version hash extension;
      };
    });

  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      inherit buildAzureCliPackage;

      # core and the actual application are highly coupled
      azure-cli-core = buildAzureCliPackage {
        pname = "azure-cli-core";
        format = "setuptools";
        inherit version src;

        sourceRoot = "${src.name}/src/azure-cli-core";

        patches = [
          # Adding the possibility to configure an immutable configuration dir via `AZURE_IMMUTABLE_DIR`.
          # This enables us to place configuration files that alter the behavior of the CLI in the Nix store.
          #
          # This is a downstream patch without an commit or PR upstream.
          # There is an issue to discuss possible solutions upstream:
          # https://github.com/Azure/azure-cli/issues/28093
          ./0001-optional-immutable-configuration-dir.patch
        ];

        propagatedBuildInputs =
          with self;
          [
            argcomplete
            azure-cli-telemetry
            azure-common
            azure-mgmt-core
            cryptography
            distro
            humanfriendly
            jmespath
            knack
            microsoft-security-utilities-secret-masker
            msal-extensions
            msal
            msrestazure
            packaging
            paramiko
            pkginfo
            psutil
            py-deviceid
            pyjwt
            pyopenssl
            requests
          ]
          ++ requests.optional-dependencies.socks;

        nativeCheckInputs = with self; [ pytest ];

        doCheck = stdenv.hostPlatform.isLinux;

        # ignore tests that does network call, or assume powershell
        checkPhase = ''
          python -c 'import azure.common; print(azure.common)'

          PYTHONPATH=$PWD:${src}/src/azure-cli-testsdk:$PYTHONPATH HOME=$TMPDIR pytest \
            azure/cli/core/tests \
            --ignore=azure/cli/core/tests/test_profile.py \
            --ignore=azure/cli/core/tests/test_generic_update.py \
            --ignore=azure/cli/core/tests/test_cloud.py \
            --ignore=azure/cli/core/tests/test_extension.py \
            --ignore=azure/cli/core/tests/test_util.py \
            --ignore=azure/cli/core/tests/test_argcomplete.py \
            -k 'not metadata_url and not test_send_raw_requests and not test_format_styled_text_legacy_powershell'
        '';

        pythonImportsCheck = [
          "azure.cli.telemetry"
          "azure.cli.core"
        ];

        meta.downloadPage = "https://github.com/Azure/azure-cli/tree/azure-cli-${version}/src/azure-cli-core/";
      };

      azure-cli-telemetry = buildAzureCliPackage {
        pname = "azure-cli-telemetry";
        version = "1.1.0";
        format = "setuptools";
        inherit src;

        sourceRoot = "${src.name}/src/azure-cli-telemetry";

        propagatedBuildInputs = with self; [
          applicationinsights
          portalocker
        ];

        nativeCheckInputs = with self; [ pytest ];
        # ignore flaky test
        checkPhase = ''
          cd azure
          HOME=$TMPDIR pytest -k 'not test_create_telemetry_note_file_from_scratch'
        '';

        meta.downloadPage = "https://github.com/Azure/azure-cli/blob/azure-cli-${version}/src/azure-cli-telemetry/";
      };

      # Error loading command module 'batch': No module named 'azure.batch._model_base'
      azure-batch = super.azure-batch.overridePythonAttrs (attrs: rec {
        version = "15.0.0b1";
        src = fetchPypi {
          pname = "azure_batch"; # Different from src.pname in the original package.
          inherit version;
          hash = "sha256-373dFY/63lIZPj5NhsmW6nI2/9JpWkNzT65eBal04u0=";
        };
      });

      azure-mgmt-billing =
        (overrideAzureMgmtPackage super.azure-mgmt-billing "6.0.0" "zip"
          "sha256-1PXFpBiKRW/h6zK2xF9VyiBpx0vkHrdpIYQLOfL1wH8="
        ).overridePythonAttrs
          (attrs: {
            propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
              self.msrest
              self.msrestazure
            ];
          });

      # AttributeError: type object 'CustomDomainsOperations' has no attribute 'disable_custom_https'
      azure-mgmt-cdn =
        overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
          "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0=";

      # ImportError: cannot import name 'ConfigMap' from 'azure.mgmt.containerinstance.models'
      azure-mgmt-containerinstance = super.azure-mgmt-containerinstance.overridePythonAttrs (attrs: rec {
        version = "10.2.0b1";
        src = fetchPypi {
          pname = "azure_mgmt_containerinstance"; # Different from src.pname in the original package.
          inherit version;
          hash = "sha256-v0u3e9ZoEnDdCnM6o6fD7N+suo5hbTqMO5jM6cSMx8A=";
        };
      });

      # ImportError: cannot import name 'ResourceSku' from 'azure.mgmt.eventgrid.models'
      azure-mgmt-eventgrid =
        overrideAzureMgmtPackage super.azure-mgmt-eventgrid "10.2.0b2" "zip"
          "sha256-QcHY1wCwQyVOEdUi06/wEa4dqJH5Ccd33gJ1Sju0qZA=";

      # ValueError: The operation 'azure.mgmt.hdinsight.operations#ExtensionsOperations.get_azure_monitor_agent_status' is invalid.
      azure-mgmt-hdinsight =
        overrideAzureMgmtPackage super.azure-mgmt-hdinsight "9.0.0b3" "tar.gz"
          "sha256-clSeCP8+7T1uI4Nec+zhzDK980C9+JGeeJFsNSwgD2Q=";

      # ValueError: The operation 'azure.mgmt.media.operations#MediaservicesOperations.create_or_update' is invalid.
      azure-mgmt-media =
        overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip"
          "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";

      # ModuleNotFoundError: No module named 'azure.mgmt.monitor.operations'
      azure-mgmt-monitor = super.azure-mgmt-monitor.overridePythonAttrs (attrs: rec {
        version = "7.0.0b1";
        src = fetchPypi {
          pname = "azure_mgmt_monitor"; # Different from src.pname in the original package.
          inherit version;
          hash = "sha256-WR4YZMw4njklpARkujsRnd6nwTZ8M5vXFcy9AfL9oj4=";
        };
      });

      # AttributeError: module 'azure.mgmt.rdbms.postgresql_flexibleservers.operations' has no attribute 'BackupsOperations'
      azure-mgmt-rdbms =
        overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b17" "tar.gz"
          "sha256-1nnRkyr4Im79B7DDqGz/FOrPAToFaGhE+a7r5bZMuOQ=";

      # ModuleNotFoundError: No module named 'azure.mgmt.redhatopenshift.v2023_11_22'
      azure-mgmt-redhatopenshift =
        overrideAzureMgmtPackage super.azure-mgmt-redhatopenshift "1.5.0" "tar.gz"
          "sha256-Uft0KcOciKzJ+ic9n4nxkwNSBmKZam19jhEiqY9fJSc=";

      # ImportError: cannot import name 'IPRule' from 'azure.mgmt.signalr.models'
      azure-mgmt-signalr =
        overrideAzureMgmtPackage super.azure-mgmt-signalr "2.0.0b2" "tar.gz"
          "sha256-05PUV8ouAKq/xhGxVEWIzDop0a7WDTV5mGVSC4sv9P4=";

      # ImportError: cannot import name 'AdvancedThreatProtectionName' from 'azure.mgmt.sql.models'
      azure-mgmt-sql = super.azure-mgmt-sql.overridePythonAttrs (attrs: rec {
        version = "4.0.0b20";
        src = fetchPypi {
          pname = "azure_mgmt_sql"; # Different from src.pname in the original package.
          inherit version;
          hash = "sha256-mphqHUet4AhmL8aUoRbrGOjbookCHR3Ex+unpOq7aQM=";
        };
      });

      # ValueError: The operation 'azure.mgmt.sqlvirtualmachine.operations#SqlVirtualMachinesOperations.begin_create_or_update' is invalid.
      azure-mgmt-sqlvirtualmachine =
        overrideAzureMgmtPackage super.azure-mgmt-sqlvirtualmachine "1.0.0b5" "zip"
          "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";

      # ModuleNotFoundError: No module named 'azure.mgmt.synapse.operations._kusto_pool_attached_database_configurations_operations'
      azure-mgmt-synapse =
        overrideAzureMgmtPackage super.azure-mgmt-synapse "2.1.0b5" "zip"
          "sha256-5E6Yf1GgNyNVjd+SeFDbhDxnOA6fOAG6oojxtCP4m+k=";

      # Observed error during runtime:
      # AttributeError: Can't get attribute 'NormalizedResponse' on <module 'msal.throttled_http_client' from
      # '/nix/store/xxx-python3.12-msal-1.32.0/lib/python3.12/site-packages/msal/throttled_http_client.py'>.
      # Did you mean: '_msal_public_app_kwargs'?
      msal =
        overrideAzureMgmtPackage super.msal "1.32.3" "tar.gz"
          "sha256-XuoDhonHilpwyo7L4SRUWLVahXvQlu+2mJxpuhWYXTU=";
    };
  };
in
py
