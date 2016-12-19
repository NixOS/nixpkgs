{ stdenv, fetchurl, kubernetes }:
let
  arch = if stdenv.isLinux
         then "linux-amd64"
         else "darwin-amd64";
  checksum = if stdenv.isLinux
             then "17r8w4lvj7fhh7qppi9z5i2fpqqry4s61zjr9zmsbybc5flnsw2j"
             else "0jf0kd1mm35qcf0ydr5yyzfq6qi8ifxchvpjsydb1gm1kikp5g3p";
in
stdenv.mkDerivation rec {
  pname = "minikube";
  version = "0.13.1";
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

    mkdir -p $out/share/bash-completion/completions/
    HOME=$(pwd) $out/bin/minikube completion bash > $out/share/bash-completion/completions/minikube
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
