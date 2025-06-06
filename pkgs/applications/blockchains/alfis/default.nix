{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  webkitgtk,
  zenity,
  Cocoa,
  Security,
  WebKit,
  withGui ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "alfis";
  version = "0.8.4-unstable-2024-03-08";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "28431ec0530405782038e7c02c2dedc3086bd7c9";
    hash = "sha256-HL4RRGXE8PIcD+zTF1xZSyOpKMhKF75Mxm6KLGsR4Hc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecies-ed25519-ng-0.5.2" = "sha256-E+jVbgKKK1DnJWAJN+xGZPCV2n7Gxp2t7XXkDNDnPN4=";
      "ureq-2.9.1" = "sha256-ATT2wJ9kmY/Jjw6FEbxqM9pDytKFLmu/ZqH/pJpZTu8=";
      "web-view-0.7.3" = "sha256-eVMcpMRZHwOdWhfV6Z1uGUNOmhB41YZPaiz1tRQvhrI=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs =
    lib.optional stdenv.isDarwin Security
    ++ lib.optional (withGui && stdenv.isLinux) webkitgtk
    ++ lib.optionals (withGui && stdenv.isDarwin) [
      Cocoa
      WebKit
    ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "doh" ] ++ lib.optional withGui "webgui";

  checkFlags = [
    # these want internet access, disable them
    "--skip=dns::client::tests::test_tcp_client"
    "--skip=dns::client::tests::test_udp_client"
  ];

  postInstall = lib.optionalString (withGui && stdenv.isLinux) ''
    wrapProgram $out/bin/alfis \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Alternative Free Identity System";
    homepage = "https://alfis.name";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = lib.platforms.unix;
    mainProgram = "alfis";
    broken = withGui && stdenv.isDarwin;
  };
}
