{ lib, fetchFromGitHub, buildGoModule, installShellFiles, fetchpatch }:

buildGoModule rec {
  pname = "gh";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0jmkcx95kngzylqhllg33s094rggpsrgky704z8v6j4969xgrfnc";
  };

  modSha256 = "0ina3m2ixkkz2fws6ifwy34pmp6kn5s3j7w40alz6vmybn2smy1h";

  buildFlagsArray = [
    "-ldflags=-X github.com/cli/cli/command.Version=${version}"
  ];

  subPackages = [ "cmd/gh" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  # should be in the next release
  # https://github.com/cli/cli/issues/401#issuecomment-586918622
  # https://github.com/cli/cli/issues/401#issuecomment-588261787
  patches = [
    (fetchpatch {
      url = "https://github.com/cli/cli/commit/213f4a5333c21020da030012979bd326a34fb28c.patch";
      sha256 = "0sp52khbbq8cfxgqs77qzxrmi7zwb12dnqps5z8sk063y30i97zp";
    })
  ];

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
