{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "todoist-${version}";
  version = "0.13.1";

  goPackagePath = "github.com/sachaos/todoist";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "1kwvlsjr2a7wdhlwpxxpdh87wz8k9yjwl59vl2g7ya6m0rvhd3mc";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = https://github.com/sachaos/todoist;
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
