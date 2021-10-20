{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "base16-universal-manager";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "base16-universal-manager";
    rev = "v${version}";
    sha256 = "11kal7x0lajzydbc2cvbsix9ympinsiqzfib7dg4b3xprqkyb9zl";
  };

  vendorSha256 = "19rba689319w3wf0b10yafydyz01kqg8b051vnijcyjyk0khwvsk";

  meta = with lib; {
    description = "A universal manager to set base16 themes for any supported application";
    homepage = "https://github.com/pinpox/base16-universal-manager";
    license = licenses.mit;
    maintainers = with maintainers; [ jo1gi ];
  };
}
