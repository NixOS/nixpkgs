{ lib
, stdenv
, fetchgit
, ninja
, pkg-config
, ed
, wrapGAppsHook3
, webkitgtk
, libxml2
, glib-networking
, gettext
}:

stdenv.mkDerivation rec {
  pname = "badwolf";
  version = "1.3.0";

  src = fetchgit {
    url = "https://hacktivis.me/git/badwolf.git";
    rev = "v${version}";
    hash = "sha256-feWSxK9TJ5MWxUKutuTcdmMk5IbLjNseUAvfm20kQ1U=";
  };

  # configure script not accepting '--prefix'
  prefixKey = "PREFIX=";

  nativeBuildInputs = [
    ninja
    pkg-config
    ed
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk
    libxml2
    gettext
    glib-networking
  ];

  meta = with lib; {
    description = "Minimalist and privacy-oriented WebKitGTK+ browser";
    mainProgram = "badwolf";
    homepage = "https://hacktivis.me/projects/badwolf";
    license = with licenses; [ bsd3 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ laalsaas aleksana ];
  };
}
