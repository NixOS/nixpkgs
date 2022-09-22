{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "restish";
  version = "0.14.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "danielgtaylor";
    repo = pname;
    hash = "sha256-AzZwu9NjRRxBu4RCa8Pzi4yg6g1SIiE8V1VC2SqLiKk=";
  };

  vendorHash = "sha256-NT928HSXWbxeyT4uunKKTjIsIAGTQtZUFh26WA/wH8Q=";

  passthru.tests.version = testers.testVersion {
    package = restish;
  };
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "CLI for interacting with REST-ish HTTP APIs with some nice features built-in";
    homepage = "https://rest.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ fumesover ];
    platforms = platforms.unix;
  };
}
