{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables, rsync, utillinux, coreutils }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1jiczhx01i8czm1gzd232z2ds2f1lvs5ifa9zjabhzw5ykfzdjg8";
  };

  buildInputs = [ makeWrapper which go iptables rsync ];

  buildPhase = ''
    substituteInPlace "hack/lib/golang.sh" --replace "_cgo" ""
    GOPATH=$(pwd)
    patchShebangs ./hack
    hack/build-go.sh --use_go_build
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp _output/local/go/bin/* "$out/bin/"
  '';

  preFixup = ''
    wrapProgram "$out/bin/kube-proxy" --prefix PATH : "${iptables}/bin"
    wrapProgram "$out/bin/kubelet" --prefix PATH : "${utillinux}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of container cluster management";
    license = licenses.asl20;
    homepage = https://github.com/GoogleCloudPlatform;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
