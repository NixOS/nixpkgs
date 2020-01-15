{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "1kwvlsjr2a7wdhlwpxxpdh87wz8k9yjwl59vl2g7ya6m0rvhd3mc";
  };

  modSha256 = "09n6abyaqwz4zcdz8934rvpbxhp4v2nmm5v739kkcc98c3h93i64";

  meta = {
    homepage = https://github.com/sachaos/todoist;
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
