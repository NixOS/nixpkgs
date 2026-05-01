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
  acrcssc = mkAzExtension {
    pname = "acrcssc";
    version = "1.0.0b5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/acrcssc-1.0.0b5-py3-none-any.whl";
    hash = "sha256-Z3wi+/3UK+TUKHE7MCSP/Es8ViGVTrlcafojw2YFRBs=";
    description = "Microsoft Azure Container Registry Container Secure Supply Chain (CSSC) Extension";
    propagatedBuildInputs = with python3Packages; [
      croniter
      oras
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  aksarc = mkAzExtension {
    pname = "aksarc";
    version = "1.5.62";
    url = "https://hybridaksstorage.z13.web.core.windows.net/HybridAKS/CLI/aksarc-1.5.62-py3-none-any.whl";
    hash = "sha256-PCy4SUbB4Vlj+fIwhufGwMJrrRehQr/W+QxAphTPnEk=";
    description = "Microsoft Azure Command-Line Tools HybridContainerService Extension";
    propagatedBuildInputs = with python3Packages; [
      kubernetes
      paramiko
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  alias = mkAzExtension rec {
    pname = "alias";
    version = "0.5.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/alias-${version}-py2.py3-none-any.whl";
    hash = "sha256-BfgtdQJueA0nvTShvlf07A9CVQDYq07n6S/uB7lE2jM=";
    description = "Support for command aliases";
    propagatedBuildInputs = with python3Packages; [
      jinja2
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  aosm = mkAzExtension rec {
    pname = "aosm";
    version = "2.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/aosm-${version}-py2.py3-none-any.whl";
    hash = "sha256-nK752/alBu0JYax8B+sp6oByPISqYGIgL6KFX5AIJmk=";
    description = "Microsoft Azure Command-Line Tools Aosm Extension";
    propagatedBuildInputs = with python3Packages; [
      genson
      jinja2
      oras
      ruamel-yaml
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  application-insights = mkAzExtension rec {
    pname = "application-insights";
    version = "2.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/application_insights-${version}-py2.py3-none-any.whl";
    hash = "sha256-4akS+zbaKxFrs0x0uKP/xX28WyK5KLduOkgZaBYeANM=";
    description = "Support for managing Application Insights components and querying metrics, events, and logs from such components";
    propagatedBuildInputs = with python3Packages; [ isodate ];
    meta.maintainers = with lib.maintainers; [ andreasvoss ];
  };

  arcappliance = mkAzExtension {
    pname = "arcappliance";
    version = "1.6.0";
    url = "https://arcplatformcliextprod.z13.web.core.windows.net/arcappliance-1.6.0-py2.py3-none-any.whl";
    hash = "sha256-1VTKp4R6ohI4C9QsZgAabJJMnkTycEQF7DDshw/7Qkw=";
    description = "Microsoft Azure Command-Line Tools Arcappliance Extension";
    propagatedBuildInputs = with python3Packages; [
      jsonschema
      kubernetes
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  arcdata = mkAzExtension {
    pname = "arcdata";
    version = "1.5.25";
    url = "https://azurearcdatacli.z13.web.core.windows.net/arcdata-1.5.25-py2.py3-none-any.whl";
    hash = "sha256-/ejgjd/O37GtS6/+gzsscImoLllaDYCl2LS8m+pulTw=";
    description = "Tools for managing ArcData";
    propagatedBuildInputs = with python3Packages; [
      jinja2
      jsonpatch
      jsonpath-ng
      jsonschema
      kubernetes
      ndjson
      pem
      pydash
      regex
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  attestation = mkAzExtension {
    pname = "attestation";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/attestation-1.0.0-py3-none-any.whl";
    hash = "sha256-5YJ3wpIhTjsKHmbeXFI0De3yX1x8NWRgsgJZ1frO70Y=";
    description = "Microsoft Azure Command-Line Tools AttestationManagementClient Extension";
    propagatedBuildInputs = with python3Packages; [
      pyjwt
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
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

  cloud-service = mkAzExtension {
    pname = "cloud-service";
    version = "1.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/cloud_service-1.0.1-py3-none-any.whl";
    hash = "sha256-9rLYCn6rO6vTGFdBtGfgHQwceKbtf/t48DG4dQBzc+Q=";
    description = "Microsoft Azure Command-Line Tools ComputeManagementClient Extension";
    propagatedBuildInputs = with python3Packages; [
      azure-mgmt-compute
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
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
    meta = {
      maintainers = with lib.maintainers; [ miampf ];
      platforms = lib.platforms.linux; # confcom is linux only
    };
  };

  connectedk8s = mkAzExtension rec {
    pname = "connectedk8s";
    version = "1.9.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/connectedk8s-${version}-py2.py3-none-any.whl";
    hash = "sha256-4OuN92PXzIWgOWhWu/S4ofQ4AbITH6XSG1soUOljY+8=";
    description = "Microsoft Azure Command-Line Tools Connectedk8s Extension";
    propagatedBuildInputs = with python3Packages; [
      azure-graphrbac
      azure-mgmt-hybridcompute
      kubernetes
      pycryptodome
      pyyaml
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  containerapp = mkAzExtension rec {
    pname = "containerapp";
    version = "1.3.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/containerapp-${version}-py2.py3-none-any.whl";
    hash = "sha256-gEFo2qBqQ19SSIMx1BWPoc19xv7lCUkuZMSUz9qPqrE=";
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

  interactive = mkAzExtension {
    pname = "interactive";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/interactive-1.0.0b1-py2.py3-none-any.whl";
    hash = "sha256-COvHDhvsigEEMYlMQ2hHFKzjX7WwdkwfT9id6z+Sj7w=";
    description = "Microsoft Azure Command-Line Interactive Shell";
    propagatedBuildInputs = with python3Packages; [
      prompt-toolkit
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
  };

  k8s-configuration = mkAzExtension rec {
    pname = "k8s-configuration";
    version = "2.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/k8s_configuration-${version}-py3-none-any.whl";
    hash = "sha256-ABkAYL19wQIiB+xuu2y/9otpSh/SSxgbuXhv5RrHP2c=";
    description = "Microsoft Azure Command-Line Tools K8s-configuration Extension";
    propagatedBuildInputs = with python3Packages; [
      pycryptodome
      pyyaml
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
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

  serial-console = mkAzExtension {
    pname = "serial-console";
    version = "1.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/serial_console-1.0.0b2-py3-none-any.whl";
    hash = "sha256-Weu4BEdq/0dvi07682UfYL8FzAd3cKZUGVJLTzJ27JM=";
    description = "Microsoft Azure Command-Line Tools for Serial Console Extension";
    propagatedBuildInputs = with python3Packages; [
      websocket-client
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
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

  webpubsub = mkAzExtension {
    pname = "webpubsub";
    version = "1.7.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/webpubsub-1.7.2-py3-none-any.whl";
    hash = "sha256-axtA9vXM1WmzXTj7rbA6Tlrx7kpx2Z6c3NYtwUiv2UI=";
    description = "Microsoft Azure Command-Line Tools Webpubsub Extension";
    propagatedBuildInputs = with python3Packages; [
      websockets
    ];
    meta.maintainers = with lib.maintainers; [ techknowlogick ];
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
