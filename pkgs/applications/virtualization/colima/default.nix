{ lib
, buildGo118Module
, fetchFromGitHub
, installShellFiles
, lima
, makeWrapper
}:

buildGo118Module rec {
  pname = "colima";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-66nKH5jxTzLB9bg2lH1E8Cc0GZ6C/N/+yPYhCVEKOBY=";

    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-91Ex3RPWxOHyZcR3Bo+bRdDAFw2mEGiC/uNKjdX2kuw=";

  doCheck = false;

  preConfigure = ''
    ldflags="-X github.com/abiosoft/colima/config.appVersion=${version}
              -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${lib.makeBinPath [ lima ]}

    installShellCompletion --cmd colima \
      --bash <($out/bin/colima completion bash) \
      --fish <($out/bin/colima completion fish) \
      --zsh <($out/bin/colima completion zsh)
  '';

  meta = with lib; {
    description = "Container runtimes on MacOS with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    maintainers = with maintainers; [ aaschmid ];
  };
}
