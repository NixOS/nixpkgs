{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lima
, makeWrapper
}:

buildGoModule rec {
  pname = "colima";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KYW3gxf21aWnuRHkysOjArzMSNH3m3XDoi6Sic3N+Po=";

    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-Z4+qwoX04VnLsUIYRfOowFLgcaA9w8oGRl77jzFigIc=";

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
