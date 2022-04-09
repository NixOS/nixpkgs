{ lib
, buildGoModule
, fetchFromGitHub
, gtk4
, glib
, gobject-introspection
, pkg-config
, go
}:

buildGoModule rec {
  pname = "gotktrix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K+q0sykdOMnAWypOXnwTU5oTokpYw61CTsAW1gIvGSQ=";
  };

  vendorSha256 = "sha256-Br9KgUoN01yoGujgbj5UEoB57K87oEH/o40rrRtIZVY=";

  buildInputs = [
    gtk4
    glib
    gobject-introspection
  ];

  nativeBuildInputs = [ pkg-config ];

  # Checking requires a working display
  doCheck = false;

  meta = with lib; {
    description = "Matrix client written in Go using GTK4";
    homepage = "https://github.com/diamondburned/gotktrix";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
