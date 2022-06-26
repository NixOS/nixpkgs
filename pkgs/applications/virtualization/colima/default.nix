{ lib
, buildGo118Module
, fetchFromGitHub
, installShellFiles
, lima
, makeWrapper
, git
, perl
, qemu
, gvproxy
, openssl
}:

buildGo118Module rec {
  pname = "colima";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tricktron";
    repo = pname;
    rev = "28099f15bb701ada2a0eecfc195b5b1638a50491";
    sha256 = "BOb0aqSdW7LWCaJA/PVAjNtvqCRbLwdOgWOM1G5jX6k=";
    # We need the git revision
    leaveDotGit = true;
  };

  nativeBuildInputs = [ installShellFiles makeWrapper git openssl ];

  vendorSha256 = "jDzDwK7qA9lKP8CfkKzfooPDrHuHI4OpiLXmX9vOpOg=";

  CGO_ENABLED = 0;

  buildPhase = ''
    runHook preBuild
    make build VERSION=0.4.2 REVISION=$(git rev-parse --short HEAD)
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    make install INSTALL_DIR=$out/bin
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${lib.makeBinPath [ lima qemu gvproxy ]}

    installShellCompletion --cmd colima \
      --bash <($out/bin/colima completion bash) \
      --fish <($out/bin/colima completion fish) \
      --zsh <($out/bin/colima completion zsh)
  '';

  meta = with lib; {
    description = "Container runtimes on MacOS with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    maintainers = with maintainers; [ aaschmid tricktron ];
  };
}
