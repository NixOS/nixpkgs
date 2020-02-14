{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "github-cli";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0jmkcx95kngzylqhllg33s094rggpsrgky704z8v6j4969xgrfnc";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # Generating completions as per https://github.com/cli/cli/issues/360#issuecomment-585419936
    $out/bin/gh completion -s bash > gh.bash    
    $out/bin/gh completion -s zsh > gh.zsh
    $out/bin/gh completion -s fish > gh.fish
    installShellCompletion gh.{bash,fish,zsh}
  '';

  modSha256 = "0ina3m2ixkkz2fws6ifwy34pmp6kn5s3j7w40alz6vmybn2smy1h";

  meta = with lib; {
    description = "The GitHub CLI tool";
    homepage = https://github.com/cli/cli;
    license = licenses.mit;
    maintainers = with maintainers; [ michaelpj ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
