{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata  }:

buildGoPackage rec {
  name = "kops-${version}";
  version = "1.4.0";
  rev = "v${version}";

  goPackagePath = "k8s.io/kops";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kubernetes";
    repo = "kops";
    sha256 = "1jwgn7l8c639j5annwymqjdw5mcajwn58y21042jy5lhgdh8pdf5";
  };

  buildInputs = [go-bindata];
  subPackages = ["cmd/kops"];

  preBuild = ''
    (cd go/src/k8s.io/kops
     go-bindata -o upup/models/bindata.go -pkg models -prefix upup/models/ upup/models/...)
  '';

  meta = with stdenv.lib; {
    description = "Easiest way to get a production Kubernetes up and running";
    homepage = https://github.com/kubernetes/kops;
    license = licenses.asl20;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
