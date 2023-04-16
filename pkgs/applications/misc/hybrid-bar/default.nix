{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, atk
, gtk3
, pango
, gdk-pixbuf
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "hybrid-bar";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "vars1ty";
    repo = "HybridBar";
    rev = version;
    hash = "sha256-e9QVDDN8AtCZYuYqef1rzLJ0mklaKXzxgj+ZqGrSYEY=";
  };

  cargoHash = "sha256-9vHoa7t9XA7zuN7MLG8Q5pDae6dznYrGMKp6H8/+Iu0=";

  buildInputs = [
    gtk3
    pango
    gdk-pixbuf
    atk
    gtk-layer-shell
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "A status bar focused on wlroots Wayland compositors";
    homepage = "https://github.com/vars1ty/HybridBar";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ocfox ];
  };
}
