{
  stdenv,
  fetchurl,
  unzip,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "ksniff";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/eldadru/ksniff/releases/download/v${version}/ksniff.zip";
    hash = "sha256-xZtcnqhNbLdxCW8SRskZtxOJ+dQjToWPSSkgiVflYf0=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    rm $out/LICENSE
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
  '';

  meta = {
    description = "Kubernetes CLI plugin for live capture of network traffic between pods";
    homepage = "https://github.com/eldadru/ksniff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ behoof4mind ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
