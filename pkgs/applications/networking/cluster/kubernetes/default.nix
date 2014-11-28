{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables,rsync }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "v0.5.4";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = version;
    sha256 = "1pipcqpjz9zsi4kfsbdvbbbia642l4xg50pznjw5v061c5xk7vnk";
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
    wrapProgram "$out/bin/kube-proxy" --set "PATH" "${iptables}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of container cluster management.";
    license = licenses.asl20;
    homepage = https://github.com/GoogleCloudPlatform;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
