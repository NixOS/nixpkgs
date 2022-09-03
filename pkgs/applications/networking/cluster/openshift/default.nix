{ lib
, buildGoModule
, fetchFromGitHub
, libkrb5
, git
, installShellFiles
, testers
, openshift
}:

buildGoModule rec {
  pname = "openshift";
  version = "4.11.0";
  gitCommit = "20dd77d5";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
    rev = "20dd77d5c889f86b05e2bdd182853ae702852c63";
    sha256 = "wqLo/CKGzeMDJUoI9PUEjJER5hSPu+FmUCJLPZ9PJuw=";
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

  passthru.tests.version = testers.testVersion {
    package = openshift;
    command = "oc version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline bachp moretea stehessel ];
    mainProgram = "oc";
    platforms = platforms.unix;
  };
}
