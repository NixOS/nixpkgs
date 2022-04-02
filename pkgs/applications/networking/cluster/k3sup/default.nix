{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, bash
, openssh
}:

buildGoModule rec {
  pname = "k3sup";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "alexellis";
    repo = "k3sup";
    rev = version;
    sha256 = "sha256-6WYUmC2uVHFGLsfkA2EUOWmmo1dSKJzI4MEdRnlLgYY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "sha256-Pd+BgPWoxf1AhP0o5SgFSvy4LyUQB7peKWJk0BMy7ds=";

  postConfigure = ''
    substituteInPlace vendor/github.com/alexellis/go-execute/pkg/v1/exec.go \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/alexellis/k3sup/cmd.GitCommit=ref/tags/${version}"
    "-X github.com/alexellis/k3sup/cmd.Version=${version}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/k3sup" \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/alexellis/k3sup";
    description = "Bootstrap Kubernetes with k3s over SSH";
    license = licenses.mit;
    maintainers = with maintainers; [ welteki ];
  };
}
