{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-MY4JvftrC6sR8M0dFvnGZOkvHIhPRcyct9AG/8527gw=";
  };

  buildAndTestSubdir = "apps/gpauth";

  cargoHash = "sha256-8LSGuRnWRWeaY6t25GdZ2y4hGIJ+mP3UBXRjcvPuD6U=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    openssl
    webkitgtk_4_1
  ];

  meta = with lib; {
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/changelog.md";
    description = "CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO authentication method";
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
