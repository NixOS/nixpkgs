{ lib, stdenv, fetchFromGitHub, pkg-config, libsoup, webkitgtk, gtk3, glib-networking
, gsettings-desktop-schemas, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "vimb";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "fanglingsu";
    repo = "vimb";
    rev = version;
    sha256 = "sha256-Eq4riJSznKpkW9JJDnTCLxZ9oMJTmWkIoGphOiCcSAg=";
  };

  nativeBuildInputs = [ wrapGAppsHook pkg-config ];
  buildInputs = [ gtk3 libsoup webkitgtk glib-networking gsettings-desktop-schemas ];

  passthru = {
    inherit gtk3;
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "A Vim-like browser";
    longDescription = ''
      A fast and lightweight vim like web browser based on the webkit web
      browser engine and the GTK toolkit. Vimb is modal like the great vim
      editor and also easily configurable during runtime. Vimb is mostly
      keyboard driven and does not detract you from your daily work.
    '';
    homepage = "https://fanglingsu.github.io/vimb/";
    license = lib.licenses.gpl3;
    maintainers = [];
    platforms = with lib.platforms; linux;
  };
}
