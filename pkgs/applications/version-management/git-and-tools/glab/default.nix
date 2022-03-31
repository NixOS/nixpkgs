{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "glab";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7w6cbeZYhmV0EXXcWlXFq2pQGGxc5Ok4bba0g3fcgmE=";
  };

  vendorSha256 = "sha256-hGpJXCs5lZ6QQHr6LW1fCT+CVtOaUpYXJPchDPDdbaM=";

  ldflags = [
    "-X main.version=${version}"
  ];

  preCheck = ''
    # failed to read configuration:  mkdir /homeless-shelter: permission denied
    export HOME=$TMPDIR
  '';

  subPackages = [ "cmd/glab" ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}
    $out/bin/glab completion --shell bash > $out/share/bash-completion/completions/glab
    $out/bin/glab completion --shell zsh > $out/share/zsh/site-functions/_glab
  '';

  meta = with lib; {
    description = "An open-source GitLab command line tool";
    license = licenses.mit;
    homepage = "https://glab.readthedocs.io/";
    maintainers = with maintainers; [ freezeboy ];
  };
}
