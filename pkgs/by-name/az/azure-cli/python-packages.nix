{
  lib,
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
        pyproject = true;
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

        build-system = with self; [ setuptools ];

        pythonRelaxDeps = true;

        dependencies =
          with self;
          [
            argcomplete
            azure-cli-telemetry
            azure-common
            azure-core
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
            --ignore=azure/cli/core/tests/test_telemetry.py \
            --ignore=azure/cli/core/tests/test_help.py \
            --ignore=azure/cli/core/tests/test_command_table_integrity.py \
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
        pyproject = true;
        inherit src;

        sourceRoot = "${src.name}/src/azure-cli-telemetry";

        build-system = with self; [ setuptools ];

        dependencies = with self; [
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

      # ImportError: cannot import name 'FeatureFlagClient' from 'azure.appconfiguration' (was dropped with 1.10.0)
      azure-appconfiguration = super.azure-appconfiguration.overridePythonAttrs (attrs: rec {
        version = "1.10.0b1";
        src = fetchPypi {
          pname = "azure_appconfiguration";
          inherit version;
          hash = "sha256-0JTwA4ahPFCYbWI8/0PNHOHxeCyUKdJ7wFkfrOaenGo=";
        };
      });

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
        (overrideAzureMgmtPackage super.azure-mgmt-cdn "12.0.0" "zip"
          "sha256-t8PuIYkjS0r1Gs4pJJJ8X9cz8950imQtbVBABnyMnd0="
        ).overridePythonAttrs
          (attrs: {
            propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
              self.msrest
            ];
          });

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
      azure-mgmt-hdinsight = super.azure-mgmt-hdinsight.overridePythonAttrs (attrs: rec {
        version = "9.1.0b2";
        src = fetchPypi {
          pname = "azure_mgmt_hdinsight";
          inherit version;
          hash = "sha256-Ww0TNeLBpzvAiRq7sXjcAGMJdW0eC8V2bBgyuftEJxc=";
        };
      });

      # ValueError: The operation 'azure.mgmt.media.operations#MediaservicesOperations.create_or_update' is invalid.
      azure-mgmt-media =
        overrideAzureMgmtPackage super.azure-mgmt-media "9.0.0" "zip"
          "sha256-TI7l8sSQ2QUgPqiE3Cu/F67Wna+KHbQS3fuIjOb95ZM=";

      # AttributeError: module 'azure.mgmt.rdbms.postgresql_flexibleservers.operations' has no attribute 'BackupsOperations'
      azure-mgmt-rdbms =
        overrideAzureMgmtPackage super.azure-mgmt-rdbms "10.2.0b17" "tar.gz"
          "sha256-1nnRkyr4Im79B7DDqGz/FOrPAToFaGhE+a7r5bZMuOQ=";

      # InvalidRequestContent: After parsing a value an unexpected character was encountered: $. Path 'location'
      azure-mgmt-resource-deployments =
        super.azure-mgmt-resource-deployments.overridePythonAttrs
          (attrs: rec {
            version = "1.0.0b1";
            src = fetchPypi {
              pname = "azure_mgmt_resource_deployments"; # Different from src.pname in the original package.
              inherit version;
              hash = "sha256-c1m0JliCbn5/8T5tuwxJDpX8yV28oiTSuFz3GtdTXx0=";
            };
          });

      # azure.mgmt.resource will shadow the other azure.mgmt.resource.* packages unless we merge them together
      azure-mgmt-resource-all = py.pkgs.buildPythonPackage {
        pname = "azure-mgmt-resource-all";
        inherit version;

        pyproject = false; # we're not building from sdist/wheel

        src = py.pkgs.azure-mgmt-resource.src;

        # No real build, just symlink all site-packages into one dir
        installPhase = ''
          runHook preInstall

          mkdir -p $out/${py.sitePackages}
          for pkg in ${
            lib.concatStringsSep " " (
              map (p: "${p}") [
                py.pkgs.azure-mgmt-resource
                py.pkgs.azure-mgmt-resource-deployments
                py.pkgs.azure-mgmt-resource-deploymentscripts
                py.pkgs.azure-mgmt-resource-deploymentstacks
                py.pkgs.azure-mgmt-resource-templatespecs
              ]
            )
          }; do
            # Copy recursively, keep symlinks, skip duplicates silently
            cp -rs --no-preserve=mode "$pkg/${py.sitePackages}/." "$out/${py.sitePackages}/" || true
          done

          runHook postInstall
        '';

        doCheck = false;
      };

      # passivestamp subpackage must be installed into recoveryservicesbackup directory.
      azure-mgmt-recoveryservicesbackup =
        super.azure-mgmt-recoveryservicesbackup.overridePythonAttrs
          (attrs: {
            dependencies = attrs.dependencies ++ [ self.azure-mgmt-recoveryservicesbackup-passivestamp ];
            postInstall = (attrs.postInstall or "") + ''
              ln -s ${self.azure-mgmt-recoveryservicesbackup-passivestamp}/${py.sitePackages}/azure/mgmt/recoveryservicesbackup/passivestamp \
                $out/${py.sitePackages}/azure/mgmt/recoveryservicesbackup/passivestamp
            '';
          });

      # ImportError: cannot import name 'AdvancedThreatProtectionName' from 'azure.mgmt.sql.models'
      azure-mgmt-sql = super.azure-mgmt-sql.overridePythonAttrs (attrs: rec {
        version = "5.0.0b2";
        src = fetchPypi {
          pname = "azure_mgmt_sql"; # Different from src.pname in the original package.
          inherit version;
          hash = "sha256-ifPodQ89xxSMUUqwPxmNn74qIxukxLjZ/seFUZi6AO8=";
        };
      });

      # azure-cli requires 6.0.0b2; nixpkgs has an older beta
      azure-mgmt-appconfiguration = super.azure-mgmt-appconfiguration.overridePythonAttrs (attrs: rec {
        version = "6.0.0b2";
        src = fetchPypi {
          pname = "azure_mgmt_appconfiguration";
          inherit version;
          hash = "sha256-Lt4HWb+rwaYsv7rx6asaBWbQoo004OX5aEsmUkeIhTQ=";
        };
      });

      # ManagedClusterAgentHostingConfiguration was removed in stable 15.0.0
      azure-mgmt-cognitiveservices = super.azure-mgmt-cognitiveservices.overridePythonAttrs (attrs: rec {
        version = "15.0.0b6";
        src = fetchPypi {
          pname = "azure_mgmt_cognitiveservices";
          inherit version;
          hash = "sha256-8bOQXoTTpMV9ZnyCa4S/vPkPOGr7IR3rlF3U5qhmzd0=";
        };
      });

      # azure-cli requires ~=41.8.0; nixpkgs has 41.5.0
      azure-mgmt-containerservice = super.azure-mgmt-containerservice.overridePythonAttrs (attrs: rec {
        version = "41.8.0";
        src = fetchPypi {
          pname = "azure_mgmt_containerservice";
          inherit version;
          hash = "sha256-h/3A/MUXhTs4ISfKi7HHRvah06xb9t5Y5gyGdU6BDVg=";
        };
      });

      # azure-cli requires 5.0.0b1; nixpkgs has 4.0.0
      azure-mgmt-iothub = super.azure-mgmt-iothub.overridePythonAttrs (attrs: rec {
        version = "5.0.0b1";
        src = fetchPypi {
          pname = "azure_mgmt_iothub";
          inherit version;
          hash = "sha256-CR8ZopF7W0hth8iOBGYqkFIGZiM9hwdGrucChNZVYgQ=";
        };
      });

      # azure-cli requires 1.1.0b4; nixpkgs has 1.0.1
      azure-mgmt-policyinsights =
        (overrideAzureMgmtPackage super.azure-mgmt-policyinsights "1.1.0b4" "zip"
          "sha256-aB16xyrhNYHJeitvdCeV+kik21B2LC+5/OSDQIGwTpI="
        ).overridePythonAttrs
          (attrs: {
            propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ self.msrest ];
          });

      # azure-cli requires 3.0.0b3; nixpkgs has stable 3.0.0
      azure-mgmt-postgresqlflexibleservers =
        super.azure-mgmt-postgresqlflexibleservers.overridePythonAttrs
          (attrs: rec {
            version = "3.0.0b3";
            src = fetchPypi {
              pname = "azure_mgmt_postgresqlflexibleservers";
              inherit version;
              hash = "sha256-obejWJMY21uN4Yg5v8hUpgOLXUYa0p3qmfMFU5u+q0o=";
            };
          });

      # nixpkgs has 4.0.0 (major bump); azure-cli requires ~=3.0.0
      azure-mgmt-redhatopenshift = super.azure-mgmt-redhatopenshift.overridePythonAttrs (attrs: rec {
        version = "3.0.0";
        src = fetchPypi {
          pname = "azure_mgmt_redhatopenshift";
          inherit version;
          hash = "sha256-R3XJvfNjI4g02hReX1n5doOrBPjdvSUN5F1F4zeYMn8=";
        };
      });

      # nixpkgs has 7.0.0 (major bump); azure-cli requires 6.0.0
      azure-mgmt-security =
        overrideAzureMgmtPackage super.azure-mgmt-security "6.0.0" "tar.gz"
          "sha256-zq/BhpiZBnEQvYMMXMmLybjzLY6oQMofaTsaX1Kl+LA=";

      # nixpkgs has 8.2.0; azure-cli requires ~=10.0.0b1
      azure-mgmt-servicebus = super.azure-mgmt-servicebus.overridePythonAttrs (attrs: rec {
        version = "10.0.0b1";
        src = fetchPypi {
          pname = "azure_mgmt_servicebus";
          inherit version;
          hash = "sha256-u7xtucS8Bn+wgnH47aNWEp1gUcRTiXeo83USD05j95w=";
        };
      });

      # azure-cli requires 1.2.0b3; nixpkgs has 1.1.0
      azure-mgmt-servicelinker = super.azure-mgmt-servicelinker.overridePythonAttrs (attrs: rec {
        version = "1.2.0b3";
        src = fetchPypi {
          pname = "azure_mgmt_servicelinker";
          inherit version;
          hash = "sha256-xRwRH7dsWeWPzsz+z9EZ+Mg+TWT9yneka2LYHsaj6ik=";
        };
      });

      # azure-cli requires 25.3.0; nixpkgs has 24.0.1
      azure-mgmt-storage = super.azure-mgmt-storage.overridePythonAttrs (attrs: rec {
        version = "25.3.0";
        src = fetchPypi {
          pname = "azure_mgmt_storage";
          inherit version;
          hash = "sha256-vE/h6ib4xYv5yms2UJXP0ybWXO+hNd1fKeCTU8tjE+w=";
        };
      });

      # nixpkgs has 2.0.0 (major bump); azure-cli requires 1.2.0
      azure-monitor-query =
        overrideAzureMgmtPackage super.azure-monitor-query "1.2.0" "zip"
          "sha256-LFdDJEPyAwaeZOUAx+lYyjFlD2QZUFFf/mVVW6E0w3E=";

      # nixpkgs has 26.0.0 which dropped ResourceManagementClient from the top-level namespace
      azure-mgmt-resource = super.azure-mgmt-resource.overridePythonAttrs (attrs: rec {
        version = "24.0.0";
        src = fetchPypi {
          pname = "azure_mgmt_resource";
          inherit version;
          hash = "sha256-z2uJlfzdQHrJ/x3UdAhxKUKaHZDbsax3+XwZuWI3smU=";
        };
      });

      # Attribute virtual_machines does not exist, requires ~=34.1.0
      azure-mgmt-compute = super.azure-mgmt-compute.overridePythonAttrs (attrs: rec {
        version = "34.1.0";
        src = fetchPypi {
          pname = "azure_mgmt_compute";
          inherit version;
          hash = "sha256-zZ010cwbjLC9JBrVXJG3fRTgSuc8YyraEUATX5whf+E=";
        };
      });
    };
  };
in
py
