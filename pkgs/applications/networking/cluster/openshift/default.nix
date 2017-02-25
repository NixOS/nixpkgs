{ stdenv, fetchFromGitHub, go, which }:

let
  version = "1.3.2";
  ver = stdenv.lib.elemAt (stdenv.lib.splitString "." version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
in
stdenv.mkDerivation rec {
  name = "openshift-origin-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "0zw8zb9c6icigcq6y47ppnjnqyghk2kril07bapbddvgnvbbfp6m";
  };

  buildInputs = [ go which ];

  patchPhase = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    export GOPATH=$(pwd)
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    export OS_GIT_VERSION=${version}
    export OS_GIT_MAJOR=${versionMajor}
    export OS_GIT_MINOR=${versionMinor}
    make build
  '';

  installPhase = ''
    export GOOS=$(go env GOOS)
    export GOARCH=$(go env GOARCH)
    mkdir -p "$out/bin"
    mv _output/local/bin/$GOOS/$GOARCH/* "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline bachp];
    platforms = platforms.linux;
  };
}
