# Manually packaged extensions for azure-cli
#
# Checkout ./README.md for more information.

{
  config,
  lib,
  mkAzExtension,
  mycli,
  python3Packages,
  autoPatchelfHook,
  python3,
  openssl_1_1,
}:

{
  application-insights = mkAzExtension rec {
    pname = "application-insights";
    version = "1.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/application_insights-${version}-py2.py3-none-any.whl";
    hash = "sha256-4fqCTrWH4r7H9MtNHEzhAzqz0/rGWvQt1iGPZzsBnO4=";
    description = "Support for managing Application Insights components and querying metrics, events, and logs from such components";
    propagatedBuildInputs = with python3Packages; [ isodate ];
    meta.maintainers = with lib.maintainers; [ andreasvoss ];
  };

  azure-devops = mkAzExtension rec {
    pname = "azure-devops";
    version = "1.0.1";
    url = "https://github.com/Azure/azure-devops-cli-extension/releases/download/20240206.1/azure_devops-${version}-py2.py3-none-any.whl";
    hash = "sha256-ZYooVNjID4dPk4LUIfpFq/ajjQAzRzfdoAb43sZM9wo=";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [ distro ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  azure-iot = mkAzExtension rec {
    pname = "azure-iot";
    description = "The Azure IoT extension for Azure CLI.";
    version = "0.25.0";
    url = "https://github.com/Azure/azure-iot-cli-extension/releases/download/v${version}/azure_iot-${version}-py3-none-any.whl";
    hash = "sha256-fbS8B2Z++oRyUT2eEh+yVR/K6uaCVce8B2itQXfBscY=";
    propagatedBuildInputs = (
      with python3Packages;
      [
        azure-core
        azure-identity
        azure-iot-device
        azure-mgmt-core
        azure-storage-blob
        jsonschema
        msrest
        msrestazure
        packaging
        tomli
        tomli-w
        tqdm
        treelib
      ]
    );
    meta.maintainers = with lib.maintainers; [ mikut ];
  };

  confcom = mkAzExtension rec {
    pname = "confcom";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/confcom-${version}-py3-none-any.whl";
    hash = "sha256-c4I+EJWKEUtKyoTDMLTevMZQxGNedMVoZ5tsMsNWQR0=";
    description = "Microsoft Azure Command-Line Tools Confidential Container Security Policy Generator Extension";
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ openssl_1_1 ];
    propagatedBuildInputs = with python3Packages; [
      pyyaml
      deepdiff
      docker
      tqdm
    ];
    postInstall = ''
      chmod +x $out/${python3.sitePackages}/azext_confcom/bin/genpolicy-linux
    '';
    meta.maintainers = with lib.maintainers; [ miampf ];
  };

  containerapp = mkAzExtension rec {
    pname = "containerapp";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/containerapp-${version}-py2.py3-none-any.whl";
    hash = "sha256-2AuDsOIncJJcJLyhUMhBgjdrewr/m28oSY12nchhi0U=";
    description = "Microsoft Azure Command-Line Tools Containerapp Extension";
    propagatedBuildInputs = with python3Packages; [
      docker
      pycomposefile
    ];
    meta.maintainers = with lib.maintainers; [ giggio ];
  };

  rdbms-connect = mkAzExtension rec {
    pname = "rdbms-connect";
    version = "1.0.6";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/rdbms_connect-${version}-py2.py3-none-any.whl";
    hash = "sha256-Scvo2bfqB6iXSimtkCR+hk7XmL7V8o0OOleks39ZOec=";
    description = "Support for testing connection to Azure Database for MySQL & PostgreSQL servers";
    propagatedBuildInputs =
      (with python3Packages; [
        pgcli
        psycopg2
        pymysql
        setproctitle
      ])
      ++ [ mycli ];
    meta.maintainers = with lib.maintainers; [ obreitwi ];
  };

  ssh = mkAzExtension rec {
    pname = "ssh";
    version = "2.0.5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/ssh-${version}-py3-none-any.whl";
    hash = "sha256-gMmLENe/HOQAW3aUrt0FxHNVRWd1umElMIvmX7D+/JM=";
    description = "SSH into Azure VMs using RBAC and AAD OpenSSH Certificates";
    propagatedBuildInputs = with python3Packages; [
      oras
      oschmod
    ];
    meta.maintainers = with lib.maintainers; [ gordon-bp ];
  };

  storage-preview = mkAzExtension rec {
    pname = "storage-preview";
    version = "1.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/storage_preview-${version}-py2.py3-none-any.whl";
    hash = "sha256-Lej6QhYikoowi7cASMP99AQAutOzSv1gHQs6/Ni4J2Q=";
    description = "Provides a preview for upcoming storage features";
    propagatedBuildInputs = with python3Packages; [ azure-core ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  vm-repair = mkAzExtension rec {
    pname = "vm-repair";
    version = "2.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/vm_repair-${version}-py2.py3-none-any.whl";
    hash = "sha256-mBa0SgKyGdxrTtrSVDp78Z0yXUMywL/9o0osKeUbhdU=";
    description = "Support for repairing Azure Virtual Machines";
    propagatedBuildInputs = with python3Packages; [ opencensus ];
    meta.maintainers = with lib.maintainers; [ ];
  };
}
// lib.optionalAttrs config.allowAliases {
  # Removed extensions
  adp = throw "The 'adp' extension for azure-cli was deprecated upstream"; # Added 2024-11-02, https://github.com/Azure/azure-cli-extensions/pull/8038
  blockchain = throw "The 'blockchain' extension for azure-cli was deprecated upstream"; # Added 2024-04-26, https://github.com/Azure/azure-cli-extensions/pull/7370
  compute-diagnostic-rp = throw "The 'compute-diagnostic-rp' extension for azure-cli was deprecated upstream"; # Added 2024-11-12, https://github.com/Azure/azure-cli-extensions/pull/8240
  connection-monitor-preview = throw "The 'connection-monitor-preview' extension for azure-cli was deprecated upstream"; # Added 2024-11-02, https://github.com/Azure/azure-cli-extensions/pull/8194
  deidservice = throw "The 'deidservice' extension for azure-cli was moved under healthcareapis"; # Added 2024-11-19, https://github.com/Azure/azure-cli-extensions/pull/8224
}
