{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "0qhmv65il14lns817yxhma784jw5bz629svzh2ykrmilx5f7dxqc";
  };

  modSha256 = "1nnp5ijz4n34gc97rar4wlvlbx21ndpjyb2mc6gxdk1wzx3mgswp";

  meta = {
    homepage = https://github.com/sachaos/todoist;
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
