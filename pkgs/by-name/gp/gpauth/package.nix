{
  rustPlatform,
  lib,
  fetchFromGitHub,
  libsoup,
  openssl,
  pkg-config,
  perl,
  webkitgtk,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-Zr888II65bUjrbStZfD0AYCXKY6VdKVJHQhbKwaY3is=";
  };

  buildAndTestSubdir = "apps/gpauth";
  cargoHash = "sha256-AuYw8CC0bMJzIJJQXhcQajQ4SACz4aKv6rG4HMq7U18=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    libsoup
    openssl
    webkitgtk
  ];

  meta = with lib; {
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/changelog.md";
    description = "A CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO authentication method";
    longDescription = ''
      A CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO
      authentication method. Inspired by gp-saml-gui.

      The CLI version is always free and open source in this repo. It has almost
      the same features as the GUI version.
    '';
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ binary-eater ];
  };
}
