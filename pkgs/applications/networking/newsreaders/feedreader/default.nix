{ stdenv
, fetchFromGitHub
, cmake
, vala
, pkgconfig
, libjson
, sqlite
, libsecret
, libnotify
, libxml2
, gettext
, glib
, json_glib
, curl
, gst_all_1
, gnome3
}:

stdenv.mkDerivation rec {
  name = "feedreader-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = "FeedReader";
    # When fetchSubmodules=true, rev can't be a tag but must be a commit hash.
    # See this issue: https://github.com/NixOS/nixpkgs/issues/26302
    #rev = "v${version}";
    rev = "c65573befe9faed5bed92359ceaa2cdf033e4e13";
    sha256 = "1jhhbkgknnv4smj5imvflsk9fmr2kgqgcxr967ih1gq1dyh4pii8";
    fetchSubmodules = true;
  };

  buildInputs = [
    cmake
    vala
    pkgconfig
    libjson
    sqlite
    libsecret
    libnotify
    libxml2
    gettext
    curl
    glib
    json_glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gnome3.libsoup
    gnome3.webkitgtk
    gnome3.rest
    gnome3.libgee
    gnome3.gnome_online_accounts
    gnome3.libpeas
  ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name
    ${glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "RSS/Atom news feed reader with synchronization";
    longDescription = ''
      A modern desktop feed reader combining all the advantages of web based
      services like synchronisation across all your devices.
    '';
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
