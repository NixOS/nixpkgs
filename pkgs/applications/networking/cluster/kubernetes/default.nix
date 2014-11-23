{ stdenv, fetchFromGitHub, which, go, makeWrapper, iptables,rsync }:

stdenv.mkDerivation rec {
  name = "kubernetes-${version}";
  version = "v0.5.2";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "kubernetes";
    rev = version;
    sha256 = "0nrm59v43jx0cskpd294q946053cfw3y2cgs53ji35dnhgj6fl6w";
  };

  buildInputs = [ makeWrapper which go iptables rsync ];

  preBuild = "patchShebangs ./hack";

  installPhase = ''
    mkdir -p "$out/bin"
    cp _output/local/go/bin/* "$out/bin/"
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
