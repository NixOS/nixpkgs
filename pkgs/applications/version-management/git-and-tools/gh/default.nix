{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0q4zpm10hcci4j0g1gx08q2qwn71ab9f7yaf4k78sfn5p89y7rm2";
  };

  vendorSha256 = "0igbqnylryiq36lbb1gha8najijzxmn10asc0xayxygbxc16s1vi";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    make GH_VERSION=${version} bin/gh manpages
  '';

  installPhase = ''
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]

    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
