{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pingu";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "CactiChameleon9";
    repo = "pingu";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pXC/y+piLhSWIcJ1/+UaC3sjHPKG3XvTuHzWENsXME0=";
    # Get values that require us to use git, then delete .git
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse --short HEAD > ldflags_revision
      find . -type d -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-8d0pKweumnJH49HSBCfEF8cwEXLGMAk2WbhS10T/Cmc=";
  ldflags = [
    "-w"
    "-s"
    "-X main.appVersion=${finalAttrs.version}"
  ];
  preBuild = ''
    ldflags+=" -X main.appRevision=$(cat ldflags_revision)"
  '';

  meta = {
    description = "Ping command implementation in Go but with colorful output and pingu ascii art";
    homepage = "https://github.com/CactiChameleon9/pingu/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CactiChameleon9 ];
    mainProgram = "pingu";
  };
})
