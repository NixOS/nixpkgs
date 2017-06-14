{ stdenv, fetchFromGitHub, which, buildGoPackage }:

let
  version = "1.5.0";
  ver = stdenv.lib.elemAt (stdenv.lib.splitString "." version);
  versionMajor = ver 0;
  versionMinor = ver 1;
  versionPatch = ver 2;
in buildGoPackage rec {
  name = "openshift-origin-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "origin";
    rev = "v${version}";
    sha256 = "0qvyxcyca3888nkgvyvqcmybm95ncwxb3zvrzbg2gz8kx6g6350v";
  };

  buildInputs = [ which ];

  goPackagePath = null;
  patchPhase = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    cd go/src/origin-v${version}-src
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    export OS_GIT_VERSION=${version}
    export OS_GIT_MAJOR=${versionMajor}
    export OS_GIT_MINOR=${versionMinor}
    make build
  '';

  installPhase = ''
    mkdir -p "$bin/bin"
    cp -a "_output/local/bin/$(go env GOOS)/$(go env GOARCH)/"* "$bin/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = http://www.openshift.org;
    maintainers = with maintainers; [offline bachp];
    platforms = platforms.linux;
  };
}
