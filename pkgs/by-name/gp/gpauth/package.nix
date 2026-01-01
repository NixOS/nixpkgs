{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  perl,
  webkitgtk_4_1,
  stdenv,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage rec {
  pname = "gpauth";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-dxRqf5iOlgJegeAqtTwoVqNHXU3eOse5eMYFknhAh2M=";
    fetchSubmodules = true;
=======
    rev = "v${version}";
    hash = "sha256-AxerhMQBgEgeecKAhedokMdpra1C9iqhutPrdAQng6Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "apps/gpauth";

<<<<<<< HEAD
  cargoHash = "sha256-VkDq98Y6uBSal7m4V9vjW1XermOPOWulo3Jo34QFRsA=";
=======
  cargoHash = "sha256-oPnBpwE8bdYgve1Dh64WNjWXClSRoHL5PVwrB1ovU6Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      booxter
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      m1dugh
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
