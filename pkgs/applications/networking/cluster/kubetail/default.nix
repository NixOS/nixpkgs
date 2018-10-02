{ stdenv, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation rec {
  name = "kubetail-${version}";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "johanhaleby";
    repo = "kubetail";
    rev = "${version}";
    sha256 = "13y3g27z2v4jx1cvphcwl0a5xshm6vcqcxasid5sbg6cpwc2xc66";
  };

  installPhase = ''
    install -Dm755 kubetail $out/bin/kubetail
  '';

  meta = with lib; {
    description = "Bash script to tail Kubernetes logs from multiple pods at the same time";
    longDescription = ''
      Bash script that enables you to aggregate (tail/follow) logs from
      multiple pods into one stream. This is the same as running "kubectl logs
      -f " but for multiple pods.
    '';
    homepage = https://github.com/johanhaleby/kubetail;
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
