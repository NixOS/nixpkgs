{ stdenv, fetchurl, unzip, lib }:

stdenv.mkDerivation rec {
  owner = "eldadru";
  pname = "ksniff";
  version = "1.6.2";

  src = fetchurl {
    url =
      "https://github.com/${owner}/${pname}/releases/download/v${version}/ksniff.zip";
    sha256 = "sha256-xZtcnqhNbLdxCW8SRskZtxOJ+dQjToWPSSkgiVflYf0=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $out/static-tcpdump $out/bin/static-tcpdump
    case ${stdenv.hostPlatform.system} in
      x86_64-linux)
        cp $out/kubectl-sniff $out/bin/kubectl-sniff
        ;;
      x86_64-darwin)
        cp $out/kubectl-sniff-darwin $out/bin/kubectl-sniff
        ;;
      aarch64-darwin)
        cp $out/kubectl-sniff-darwin-arm64 $out/bin/kubectl-sniff
        ;;
      *)
        echo "Unsupported system: ${stdenv.hostPlatform.system}"
        exit 1
        ;;
    esac
    mv $out/LICENSE $out/LICENSE.ksniff
  '';

  meta = with lib; {
    description =
      "Kubernetes CLI plugin for live capture of network traffic between pods";
    homepage = "https://github.com/eldadru/ksniff";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers.behoof4mind ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
