{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "blocky";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vG6QAI8gBI2nLRQ0nOFWQHihyzgmJu69rgkWlg3iW3E=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go
  doCheck = false;

  vendorSha256 = "sha256-+mpNPDejK9Trhw41SUXJPL/OX5wQR0QfA2+BXSlE0Jk=";

  meta = with lib; {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features.";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ ratsclub ];
  };
}
