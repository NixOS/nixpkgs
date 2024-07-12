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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-ADjZGoVz2Qo0cS8FZ4Eke+1W4JkSllhl8IxM0fXto0k=";
  };

  buildAndTestSubdir = "apps/gpauth";
  cargoHash = "sha256-Fqu5S8rXnQkSGvUZnbjQt4zJGTV8ZJytTg9YRwkpwCA=";

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
