{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, makeWrapper
, webkitgtk
, zenity
, Cocoa
, Security
, WebKit
, withGui ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "alfis";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    sha256 = "sha256-QOKFnre5MW9EvrKrKBHWpOxi2fBKTDMhzCDX3ISd2cQ=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "bump-rust-web-view.patch";
      url = "https://github.com/Revertron/Alfis/commit/03b461a740ab6ccbacd576eafc7a3faf4a66648f.patch";
      sha256 = "sha256-CSqSMdVD31w7QxxXWtjKmqlaEirmbs1EVuiefSf1NKY=";
    })
  ];

  cargoSha256 = "sha256-B4xI++U6RCljXCyaOmNj/SwA6I16zoiZsgk2VTiKfkg=";

  checkFlags = [
    # these want internet access, disable them
    "--skip=dns::client::tests::test_tcp_client"
    "--skip=dns::client::tests::test_udp_client"
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = lib.optional stdenv.isDarwin Security
    ++ lib.optional (withGui && stdenv.isLinux) webkitgtk
    ++ lib.optionals (withGui && stdenv.isDarwin) [ Cocoa WebKit ];

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
  };
}
