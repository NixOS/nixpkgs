{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "todoist-${version}";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "1kwvlsjr2a7wdhlwpxxpdh87wz8k9yjwl59vl2g7ya6m0rvhd3mc";
  };

  modSha256 = "0ng1paw2mizhs4g28ypxz0ryh43l90qw8qsq46sshsiiswvrpl0k";

  meta = {
    homepage = https://github.com/sachaos/todoist;
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
