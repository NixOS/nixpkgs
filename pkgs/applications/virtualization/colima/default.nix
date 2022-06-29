{ lib
, buildGo118Module
, fetchFromGitHub
, installShellFiles
, lima-unwrapped
, makeWrapper
, git
, perl
, qemu
, openssl
}:

buildGo118Module rec {
  pname = "colima";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "tieQOqcbTT6ODUEcLLwWUD7tDOAb6mklbUecjeVjhRc=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
       git -C $out rev-parse --short HEAD > $out/.git-revision
       rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper git openssl ];

  vendorSha256 = "jDzDwK7qA9lKP8CfkKzfooPDrHuHI4OpiLXmX9vOpOg=";

  CGO_ENABLED = 0;

  buildPhase = ''
    runHook preBuild
    make build VERSION=${version} REVISION=$(cat .git-revision)
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
      --prefix PATH : ${lib.makeBinPath [ lima-unwrapped qemu ]}

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
