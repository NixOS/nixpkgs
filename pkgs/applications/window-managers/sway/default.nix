{ stdenv, fetchFromGitHub
, cmake
, meson, ninja
, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pcre, json_c, dbus
, pango, cairo, libinput, libcap, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp, wlroots, wayland-protocols, git
, buildDocs ? true
}:

let
  versions = {
    sway = {
      version = "0.15.2";
      sha256 = "1p9j5gv85lsgj4z28qja07dqyvqk41w6mlaflvvm9yxafx477g5n";
      cmakeBuild = true;
    };

    sway-beta = {
      version = "1.0-beta.1";
      sha256 = "0h9kgrg9mh2acks63z72bw3lwff32pf2nb4i7i5xhd9i6l4gfnqa";
      mesonBuild = true;
    };
  };

  common = pname: {version, sha256, cmakeBuild ? false, mesonBuild ? false}: stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = version;
      inherit sha256;
    };

    nativeBuildInputs = [
      pkgconfig
    ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl
    ] ++ stdenv.lib.optional cmakeBuild [ cmake
    ] ++ stdenv.lib.optional mesonBuild [ meson ninja
    ];


    buildInputs = [
      wayland wlc libxkbcommon pcre json_c dbus
      pango cairo libinput libcap pam gdk_pixbuf libpthreadstubs
      libXdmcp wlroots wayland-protocols git
    ];

    enableParallelBuilding = true;

    cmakeFlags = "-DVERSION=${version} -DLD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib:";

    meta = with stdenv.lib; {
      description = "i3-compatible window manager for Wayland";
      homepage    = http://swaywm.org;
      license     = licenses.mit;
      platforms   = platforms.linux;
      maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
    };
  };
in stdenv.lib.mapAttrs common versions
