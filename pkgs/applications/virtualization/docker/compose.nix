{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-compose";
  version = "2.23.3";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    hash = "sha256-Rp13xK7pRyjHaDclAfL+yzNf4ppOy9S+XFbydj4TDL4=";
  };

  postPatch = ''
    # entirely separate package that breaks the build
    rm -rf e2e/
  '';

  vendorHash = "sha256-iKBMd4e1oVNdKuk08tYPexQqs9JLofhdf4yEP1s97EQ=";

  ldflags = [ "-X github.com/docker/compose/v2/internal.Version=${version}" "-s" "-w" ];

  doCheck = false;
  installPhase = ''
    runHook preInstall
    install -D $GOPATH/bin/cmd $out/libexec/docker/cli-plugins/docker-compose

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-compose $out/bin/docker-compose
    runHook postInstall
  '';

  meta = with lib; {
    description = "Docker CLI plugin to define and run multi-container applications with Docker";
    homepage = "https://github.com/docker/compose";
    license = licenses.asl20;
    maintainers = with maintainers; [ babariviere ];
  };
}
