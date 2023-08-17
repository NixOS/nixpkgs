{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, cairo
, glib
, gtk3
, openssl
, pango
, testers
, buzz
}:

rustPlatform.buildRustPackage rec{
  pname = "buzz";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-k3tAZ88ppG9eas2LPLN/RiTCAoQ1FxoVtZFiAbaj8+o=";
  };

  cargoHash = "sha256-zGRS4XuDGDsuvc/JIzVqROkvuEtIoJn3XPdWZwNUM9s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cairo
    glib
    gtk3
    openssl
    pango
  ];

  passthru.tests.version = testers.testVersion {
    package = buzz;
  };

  meta = with lib; {
    description = "A simple system tray application for notifying about unseen e-mail";
    homepage = "https://github.com/jonhoo/buzz";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.linux;
  };
}
