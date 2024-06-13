{ lib, stdenv, fetchzip, jre }:

stdenv.mkDerivation rec {
  pname = "atlassian-cli";
  version = "9.6.0";

  src = fetchzip {
    url  = "https://bobswift.atlassian.net/wiki/download/attachments/16285777/${pname}-${version}-distribution.zip";
    sha256  = "sha256-55ydhprVC9NdDMUrKbpSAEQBb9zRYgwOc7k8aP4R89A=";
  };

  tools = [
    "agile"
    "bamboo"
    "bitbucket"
    "confluence"
    "csv"
    "hipchat"
    "jira"
    "servicedesk"
    "structure"
    "tempo"
    "trello"
    "upm"
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/doc/atlassian-cli}
    cp -r lib $out/share/java
    cp -r README.txt license $out/share/doc/atlassian-cli
    for tool in $tools
    do
      substitute ${./wrapper.sh} $out/bin/$tool \
        --subst-var out \
        --subst-var-by jre ${jre} \
        --subst-var-by tool $tool
      chmod +x $out/bin/$tool
    done
  '';

  meta = with lib; {
    description = "Integrated family of CLI’s for various Atlassian applications";
    homepage = "https://bobswift.atlassian.net/wiki/spaces/ACLI/overview";
    license = licenses.unfreeRedistributable;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ twey ];
    inherit (jre.meta) platforms;
  };
}
