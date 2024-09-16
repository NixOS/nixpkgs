# Manually packaged extensions for azure-cli
#
# Checkout ./README.md for more information.

{
  lib,
  mkAzExtension,
  mycli,
  python3Packages,
}:

{
  application-insights = mkAzExtension rec {
    pname = "application-insights";
    version = "1.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/application_insights-${version}-py2.py3-none-any.whl";
    sha256 = "e1fa824eb587e2bec7f4cb4d1c4ce1033ab3d3fac65af42dd6218f673b019cee";
    description = "Support for managing Application Insights components and querying metrics, events, and logs from such components";
    propagatedBuildInputs = with python3Packages; [ isodate ];
    meta.maintainers = with lib.maintainers; [ andreasvoss ];
  };

  azure-devops = mkAzExtension rec {
    pname = "azure-devops";
    version = "1.0.1";
    url = "https://github.com/Azure/azure-devops-cli-extension/releases/download/20240206.1/azure_devops-${version}-py2.py3-none-any.whl";
    sha256 = "658a2854d8c80f874f9382d421fa45abf6a38d00334737dda006f8dec64cf70a";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [ distro ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  containerapp = mkAzExtension rec {
    pname = "containerapp";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/containerapp-${version}-py2.py3-none-any.whl";
    sha256 = "d80b83b0e22770925c24bca150c84182376b7b0aff9b6f28498d769dc8618b45";
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
    sha256 = "49cbe8d9b7ea07a8974a29ad90247e864ed798bed5f28d0e3a57a4b37f5939e7";
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
    sha256 = "80c98b10d7bf1ce4005b7694aedd05c47355456775ba6125308be65fb0fefc93";
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
    sha256 = "2de8fa421622928a308bb70048c3fdf40400bad3b34afd601d0b3afcd8b82764";
    description = "Provides a preview for upcoming storage features";
    propagatedBuildInputs = with python3Packages; [ azure-core ];
    meta.maintainers = with lib.maintainers; [ katexochen ];
  };

  # Removed extensions
  blockchain = throw "The 'blockchain' extension for azure-cli was deprecated upstream"; # Added 2024-04-26
  vm-repair = throw "The 'vm-repair' extension for azure-cli was deprecated upstream"; # Added 2024-08-06
}
