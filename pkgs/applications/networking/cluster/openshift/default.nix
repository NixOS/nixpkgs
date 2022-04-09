{ lib
, buildGoModule
, fetchFromGitHub
, libkrb5
, git
, installShellFiles
, testVersion
, openshift
}:

buildGoModule rec {
  pname = "openshift";
  version = "4.10.0";
  gitCommit = "346b183";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
    rev = "release-4.10";
    sha256 = "Pdq3OwT5P7vvB70X+GVglT9CdJbhkm35nvEGurO1HPc=";
  };

  vendorSha256 = null;

  buildInputs = [ libkrb5 ];

  nativeBuildInputs = [ installShellFiles ];

  patchPhase = ''
    patchShebangs ./hack
  '';

  buildPhase = ''
    # Openshift build require this variables to be set
    # unless there is a .git folder which is not the case with fetchFromGitHub
    export SOURCE_GIT_COMMIT=${gitCommit}
    export SOURCE_GIT_TAG=v${version}
    export SOURCE_GIT_TREE_STATE=clean

    make all
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp oc $out/bin

    mkdir -p man
    ./genman man oc
    installManPage man/*.1

    installShellCompletion --bash contrib/completions/bash/*
    installShellCompletion --zsh contrib/completions/zsh/*
  '';

  passthru.tests.version = testVersion {
    package = openshift;
    command = "oc version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    license = licenses.asl20;
    homepage = "http://www.openshift.org";
    maintainers = with maintainers; [ offline bachp moretea stehessel ];
    platforms = platforms.unix;
  };
}
