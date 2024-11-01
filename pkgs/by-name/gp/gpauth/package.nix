{
  rustPlatform,
  lib,
  fetchFromGitHub,
  libsoup,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-ZIAY0Dkv6uukCfh9e2D6h5ZxVdZX/04laV09mmu5Fm0=";
  };

  buildAndTestSubdir = "apps/gpauth";
  cargoHash = "sha256-mk6vIIinSppmiJXYlt7uCxjpKq1YpYtKhu3t8saJd/k=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    libsoup
    openssl
    webkitgtk_4_0
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
