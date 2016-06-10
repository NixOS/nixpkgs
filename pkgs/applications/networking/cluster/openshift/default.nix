{ stdenv, fetchgit, go, git, which }:

stdenv.mkDerivation rec {
  name = "openshift-origin-${version}";
  version = "1.0.1";

  src = fetchgit {
    url = https://github.com/openshift/origin.git;
    rev = "1b601951daa44964c9bc7e4a2264d65489e3a58c";
    sha256 = "0hvipgnkpph81jx6h6bar49j5zkrxzi6h71b4y75c0l7af129wdi";
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
