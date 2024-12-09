{
  rustPlatform,
  lib,
  fetchFromGitHub,
  libsoup_2_4,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-s+uCpNrwQvdIINLSIbtcCCBg469J2xtlyiwDYqtXrQs=";
  };

  buildAndTestSubdir = "apps/gpauth";
  cargoHash = "sha256-QHqPVsMPKgAhhZwah3g1jqidl3UnvvKZnM4r1coUHSs=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    libsoup_2_4
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
    maintainers = with maintainers; [
      binary-eater
      m1dugh
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
