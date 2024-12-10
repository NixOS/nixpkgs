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
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    sha256 = "sha256-BNpz4SjWeZ20CxjyEIaFI43X7P3uoyWqOQssFb38Gv8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "web-view-0.7.3" = "sha256-8C/2bXAbxP5tdo9RLvNn89krzy08+yKy3kERfz31HJE=";
    };
  };

  checkFlags = [
    # these want internet access, disable them
    "--skip=dns::client::tests::test_tcp_client"
    "--skip=dns::client::tests::test_udp_client"
  ];

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
  buildFeatures = [
    "doh"
  ] ++ lib.optional withGui "webgui";

  postInstall = lib.optionalString (withGui && stdenv.isLinux) ''
    wrapProgram $out/bin/alfis \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = with lib; {
    description = "Alternative Free Identity System";
    homepage = "https://alfis.name";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ misuzu ];
    platforms = platforms.unix;
    mainProgram = "alfis";
  };
}
