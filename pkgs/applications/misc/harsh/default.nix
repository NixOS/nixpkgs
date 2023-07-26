{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "harsh";
  version = "0.8.28";

  src = fetchFromGitHub {
    owner = "wakatara";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6BeGyyy4RFBy4TvB3bLTyDtQGljG9xE3VFfbnq9KWcs=";
  };

  vendorHash = "sha256-zkz7X/qj8FwtQZXGuq4Oaoe5G9a4AJE1kv3j7wwQEp4=";

  meta = with lib; {
    description = "CLI habit tracking for geeks";
    homepage = "https://github.com/wakatara/harsh";
    changelog = "https://github.com/wakatara/harsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ laurailway ];
  };
}
