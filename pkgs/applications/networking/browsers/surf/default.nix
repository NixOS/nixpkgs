{ lib, stdenv, fetchgit
, pkg-config, wrapGAppsHook
, glib, gcr, glib-networking, gsettings-desktop-schemas, gtk, libsoup, webkitgtk
, xorg, dmenu, findutils, gnused, coreutils
, patches ? null
}:

stdenv.mkDerivation rec {
  pname = "surf";
  version = "2.1";

  # tarball is missing file common.h
  src = fetchgit {
    url = "git://git.suckless.org/surf";
    rev = version;
    sha256 = "1v926hiayddylq79n8l7dy51bm0dsa9n18nx9bkhg666cx973x4z";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ glib gcr glib-networking gsettings-desktop-schemas gtk libsoup webkitgtk ];

  inherit patches;

  makeFlags = [ "PREFIX=$(out)" ];

  # Add run-time dependencies to PATH. Append them to PATH so the user can
  # override the dependencies with their own PATH.
  preFixup = let
    depsPath = lib.makeBinPath [ xorg.xprop dmenu findutils gnused coreutils ];
  in ''
    gappsWrapperArgs+=(
      --suffix PATH : ${depsPath}
    )
  '';

  meta = with lib; {
    description = "A simple web browser based on WebKitGTK";
    longDescription = ''
      surf is a simple web browser based on WebKitGTK. It is able to display
      websites and follow links. It supports the XEmbed protocol which makes it
      possible to embed it in another application. Furthermore, one can point
      surf to another URI by setting its XProperties.
    '';
    homepage = "https://surf.suckless.org";
    license = licenses.mit;
    platforms = webkitgtk.meta.platforms;
    maintainers = with maintainers; [ joachifm ];
  };
}
