{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables, rsync, utillinux, coreutils }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = "v${version}";
    sha256 = "1891wpssfp04nkk1h4y3cdgn096b0kq16pc0m2fzilbh3daa6pml";
  };

  buildInputs = [ makeWrapper which go iptables rsync ];

  preBuild = "patchShebangs ./hack";

  postBuild = ''go build --ldflags '-extldflags "-static" -s' build/pause/pause.go'';

  installPhase = ''
    mkdir -p "$out/bin"
    cp _output/local/go/bin/* "$out/bin/"
    cp pause $out/bin/kube-pause
  '';

  preFixup = ''
    wrapProgram "$out/bin/kube-proxy" --prefix PATH : "${iptables}/bin"
    wrapProgram "$out/bin/kubelet" --prefix PATH : "${utillinux}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of container cluster management.";
    license = licenses.asl20;
    homepage = https://github.com/GoogleCloudPlatform;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
  };
}
