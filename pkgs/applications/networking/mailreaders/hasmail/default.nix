{ lib
, buildGoModule
, fetchFromGitHub
, pkgconfig
, gobject-introspection
, pango
, cairo
, gtk2
}:

buildGoModule rec {
  pname = "hasmail-unstable";
  version = "2019-08-24";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "hasmail";
    rev = "eb52536d26815383bfe5990cd5ace8bb9d036c8d";
    sha256 = "1p6kwa5xk1mb1fkkxz1b5rcyp5kb4zc8nfif1gk6fab6wbdj9ia1";
  };

  vendorSha256 = "0sblgjmn3i3k31jfq5zy3bx7bv5z2cg6rjzr7aj87c57yhzzcmk7";

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    pango
    cairo
    gtk2
  ];

  meta = with lib; {
    description = "Simple tray icon for detecting new email on IMAP servers";
    homepage = "https://github.com/jonhoo/hasmail";
    license = licenses.unlicense;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
