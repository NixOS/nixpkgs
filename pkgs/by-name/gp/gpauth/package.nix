{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_1,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    rev = "v${version}";
    hash = "sha256-AxerhMQBgEgeecKAhedokMdpra1C9iqhutPrdAQng6Q=";
  };

  buildAndTestSubdir = "apps/gpauth";

  cargoHash = "sha256-oPnBpwE8bdYgve1Dh64WNjWXClSRoHL5PVwrB1ovU6Y=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  meta = {
    changelog = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/changelog.md";
    description = "CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO authentication method";
    longDescription = ''
      A CLI for GlobalProtect VPN, based on OpenConnect, supports the SSO
      authentication method. Inspired by gp-saml-gui.

      The CLI version is always free and open source in this repo. It has almost
      the same features as the GUI version.
    '';
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      binary-eater
      m1dugh
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
