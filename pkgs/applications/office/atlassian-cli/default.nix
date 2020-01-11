{ stdenv, fetchzip, jre }:

stdenv.mkDerivation rec {
  pname = "atlassian-cli";
  version = "9.0.0";
  
  src = fetchzip {
    url  = "https://bobswift.atlassian.net/wiki/download/attachments/16285777/${pname}-${version}-distribution.zip";
    sha256  = "1z8723krq65fcy5aapgiz216vrpw2nw8fbn1h3a4zpis7kw8qp0f";
    extraPostFetch = "chmod go-w $out";
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
  
  meta = with stdenv.lib; {
    description = "An integrated family of CLI’s for various Atlassian applications";
    homepage = https://bobswift.atlassian.net/wiki/spaces/ACLI/overview;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ twey ];
    inherit (jre.meta) platforms;
  };
}
