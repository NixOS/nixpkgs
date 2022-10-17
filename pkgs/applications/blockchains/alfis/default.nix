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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    sha256 = "sha256-E0n1keNk5jNnErNvYhb8oe26kK9Opl+IJ5zpsvrqS84=";
  };

  cargoSha256 = "sha256-kbo3OMLYA/5xctz/YhQNd8IYlyCQB7D/8rCHZwjvlMI=";

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
