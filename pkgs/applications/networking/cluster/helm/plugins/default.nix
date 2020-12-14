{ stdenv, fetchFromGitHub, fetchurl, fetchzip }:
let

  buildHelmPlugin = { name, ... }@attrs:
    fetchzip (attrs // {
      stripRoot = false;
    });
in {

  helm-s3 = let
    pname = "helm-s3";
    version = "0.10.0";
  in buildHelmPlugin rec {
    name = "${pname}-${version}";
    url = "https://github.com/hypnoglow/helm-s3/releases/download/v${version}/helm-s3_${version}_linux_amd64.tar.gz";
    sha256 = "sha256-pTux7HArWB5yO1Oehfd+ZpeGUziI2+wfUart5WfkQW4=";

    extraPostFetch = ''
      mkdir $out/${pname}
      GLOBIGNORE="$out/${pname}"
      mv $out/* -t $out/${pname}
    '';
  };

  helm-diff = buildHelmPlugin {
    name = "helm-diff";
    url = "https://github.com/databus23/helm-diff/releases/download/v3.1.3/helm-diff-linux.tgz";
    sha256 = "sha256-oGmBPcCyUgq2YD4+CkGrbf6/JhzXJjmkaiqX/3a03aE=";
  };

  helm-secrets = buildHelmPlugin {
    name = "helm-secrets";
    url = "https://github.com/jkroepke/helm-secrets/releases/download/v3.4.1/helm-secrets.tar.gz";
    sha256 = "sha256-HXwbs/bXJXF75FbLB/En0jirCQnz8HpU3o9LeMyV0e8=";
  };
}
