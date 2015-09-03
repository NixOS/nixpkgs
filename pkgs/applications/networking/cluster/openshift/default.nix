{ stdenv, fetchgit, go, git, which }:

stdenv.mkDerivation rec {
  name = "openshift-origin-${version}";
  version = "1.0.1";

  src = fetchgit {
    url = https://github.com/openshift/origin.git;
    rev = "1b601951daa44964c9bc7e4a2264d65489e3a58c";
    sha256 = "0nwyj3cgajmbd356w0362zxkd3p3pply58an2bmi3d3bswp3k89g";
    leaveDotGit = true;
    deepClone = true;
  };

  buildInputs = [ go git which ];

  buildPhase = "hack/build-go.sh";

  installPhase = ''
    mkdir -p "$out/bin"
    cp _output/local/go/bin/* "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline];
    platforms = [ "x86_64-linux" ];
    broken = true;
  };
}
