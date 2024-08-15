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
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    hash = "sha256-ettStNktSDZnYNN/IWqTB1Ou1g1QEGFabS4EatnDLaE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecies-ed25519-ng-0.5.3" = "sha256-sJZ5JCaGNa3DdAaHw7/2qeLYv+HDKEMcY4uHbzfzQBM=";
      "ureq-2.10.0" = "sha256-XNjY8qTgt2OzlfKu7ECIfgRLkSlprvjpgITsNVMi1uc=";
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
