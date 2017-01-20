{ stdenv, fetchurl, kubernetes }:
let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "1g6k3va84nm2h9z2ywbbkc8jabgkarqlf8wv1sp2p6s6hw7hi5h3"
             else "0jpwyvgpl34n07chcyd7ldvk3jq3rx72cp8yf0bh7gnzr5lcnxnc";
in
stdenv.mkDerivation rec {
  pname = "minikube";
  version = "0.15.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://storage.googleapis.com/minikube/releases/v${version}/minikube-${arch}";
    sha256 = "${checksum}";
  };

  buildInputs = [ ];

  propagatedBuildInputs = [ kubernetes ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    cp $src $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
