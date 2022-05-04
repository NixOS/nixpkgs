{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    sha256 = "sha256-lamobXaDY+v8NpoI+TuuBO5Cdol9+7VPhdmLEH6sZIo=";
  };

  cargoSha256 = "sha256-C5MCT4EG/lI4s2rVGSm9DgBu43FKpp3iTBbCf7N1jOA=";

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
