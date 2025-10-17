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
    version = "2.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/application_insights-${version}-py2.py3-none-any.whl";
    hash = "sha256-4akS+zbaKxFrs0x0uKP/xX28WyK5KLduOkgZaBYeANM=";
    description = "Support for managing Application Insights components and querying metrics, events, and logs from such components";
    propagatedBuildInputs = with python3Packages; [ isodate ];
    meta.maintainers = with lib.maintainers; [ andreasvoss ];
  };

  azure-devops = mkAzExtension rec {
    pname = "azure-devops";
    version = "1.0.2";
    url = "https://github.com/Azure/azure-cli-extensions/releases/download/azure-devops-${version}/azure_devops-${version}-py2.py3-none-any.whl";
    hash = "sha256-4rDeAqOnRRKMP26MJxG4u9vBuos6/SQIoVgfNbBpulk=";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [ distro ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  azure-iot = mkAzExtension rec {
    pname = "azure-iot";
    description = "Azure IoT extension for Azure CLI";
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
    version = "1.2.6";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/confcom-${version}-py3-none-any.whl";
    hash = "sha256-kyJ4AkPcpP/10nf4whJiuraC7hn0E6iBkhRIn43E9J0=";
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
    version = "1.2.0b3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/containerapp-${version}-py2.py3-none-any.whl";
    hash = "sha256-UK7fbWI7NoW8sBo3OEafXX3DolFNQXhFDMHUoE1h/qA=";
    description = "Microsoft Azure Command-Line Tools Containerapp Extension";
    propagatedBuildInputs = with python3Packages; [
      docker
      pycomposefile
      kubernetes
    ];
    meta.maintainers = with lib.maintainers; [ giggio ];
  };

  k8s-extension = mkAzExtension rec {
    pname = "k8s-extension";
    version = "1.7.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/k8s_extension-${version}-py3-none-any.whl";
    hash = "sha256-gyQxHfsXd+V6w2jMBNiYpE1MrqFeHei9RlsVhXgOjW8=";
    description = "Microsoft Azure Command-Line Tools K8s-extension Extension";
    propagatedBuildInputs = with python3Packages; [
      kubernetes
      oras
    ];
    meta.maintainers = [ ];
  };

  rdbms-connect = mkAzExtension rec {
    pname = "rdbms-connect";
    version = "1.0.7";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/rdbms_connect-${version}-py2.py3-none-any.whl";
    hash = "sha256-66mX1K1azQvbuApyKBwvVuiKCbLaqezCDdrv0lhvVD0=";
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
    version = "2.0.6";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/ssh-${version}-py3-none-any.whl";
    hash = "sha256-PSIGtOa91WxpzFCauZ5d5tx/ZtCRsBhbejtVfY3Bgss=";
    description = "SSH into Azure VMs using RBAC and AAD OpenSSH Certificates";
    propagatedBuildInputs = with python3Packages; [
      oras
      oschmod
    ];
    meta = {
      maintainers = with lib.maintainers; [ gordon-bp ];
      changelog = "https://github.com/Azure/azure-cli-extensions/blob/ssh-${version}/src/ssh/HISTORY.md";
    };
  };

  storage-preview = mkAzExtension rec {
    pname = "storage-preview";
    version = "1.0.0b7";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/storage_preview-${version}-py2.py3-none-any.whl";
    hash = "sha256-wtf+4TBDzpWO55w5VXnoERAbksP2QaSc29FHL3MNOBo=";
    description = "Provides a preview for upcoming storage features";
    propagatedBuildInputs = with python3Packages; [ azure-core ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  vm-repair = mkAzExtension rec {
    pname = "vm-repair";
    version = "2.1.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/vm_repair-${version}-py2.py3-none-any.whl";
    hash = "sha256-DOuH7BG4WrhP7SQH3GInFh7DHT0qN3JhSG76EXmNn24=";
    description = "Support for repairing Azure Virtual Machines";
    propagatedBuildInputs = with python3Packages; [ opencensus ];
    meta.maintainers = [ ];
  };
}
// lib.optionalAttrs config.allowAliases {
  # Removed extensions
  adp = throw "The 'adp' extension for azure-cli was deprecated upstream"; # Added 2024-11-02, https://github.com/Azure/azure-cli-extensions/pull/8038
  akshybrid = throw "The 'akshybrid' extension for azure-cli was removed upstream"; # https://github.com/Azure/azure-cli-extensions/pull/8955
  azurestackhci = throw "The 'azurestackhci' extension for azure-cli was deprecated upstream"; # Added 2025-07-01, https://github.com/Azure/azure-cli-extensions/pull/8898
  blockchain = throw "The 'blockchain' extension for azure-cli was deprecated upstream"; # Added 2024-04-26, https://github.com/Azure/azure-cli-extensions/pull/7370
  compute-diagnostic-rp = throw "The 'compute-diagnostic-rp' extension for azure-cli was deprecated upstream"; # Added 2024-11-12, https://github.com/Azure/azure-cli-extensions/pull/8240
  connection-monitor-preview = throw "The 'connection-monitor-preview' extension for azure-cli was deprecated upstream"; # Added 2024-11-02, https://github.com/Azure/azure-cli-extensions/pull/8194
  csvmware = throw "The 'csvmware' extension for azure-cli was removed upstream"; # https://github.com/Azure/azure-cli-extensions/pull/8931
  deidservice = throw "The 'deidservice' extension for azure-cli was moved under healthcareapis"; # Added 2024-11-19, https://github.com/Azure/azure-cli-extensions/pull/8224
  hdinsightonaks = throw "The 'hdinsightonaks' extension for azure-cli was removed upstream"; # https://github.com/Azure/azure-cli-extensions/pull/8956
  logz = throw "The 'logz' extension for azure-cli was deprecated upstream"; # Added 2024-11-02, https://github.com/Azure/azure-cli-extensions/pull/8459
  pinecone = throw "The 'pinecone' extension for azure-cli was removed upstream"; # Added 2025-06-03, https://github.com/Azure/azure-cli-extensions/pull/8763
  playwright-cli-extension = throw "The 'playwright-cli-extension' extension for azure-cli was removed upstream"; # https://github.com/Azure/azure-cli-extensions/pull/9156
  sap-hana = throw "The 'sap-hana' extension for azure-cli was deprecated upstream"; # Added 2025-07-01, https://github.com/Azure/azure-cli-extensions/pull/8904
  spring = throw "The 'spring' extension for azure-cli was deprecated upstream"; # Added 2025-05-07, https://github.com/Azure/azure-cli-extensions/pull/8652
  spring-cloud = throw "The 'spring-cloud' extension for azure-cli was deprecated upstream"; # Added 2025-07-01 https://github.com/Azure/azure-cli-extensions/pull/8897
  weights-and-biases = throw "The 'weights-and-biases' was removed upstream"; # Added 2025-06-03, https://github.com/Azure/azure-cli-extensions/pull/8764
}
