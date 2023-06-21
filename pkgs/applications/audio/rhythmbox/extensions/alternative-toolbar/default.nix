{ stdenv, fetchFromGitHub, rhythmbox, pkg-config, which, intltool, glib, gst_all_1, gtk3, libpeas, gobject-introspection, autoconf, automake, python3 }:

stdenv.mkDerivation rec {
    name = "rhythmbox-extension-alternative-toolbar";
    version = "0.20.3";

    src = fetchFromGitHub {
        owner = "fossfreedom";
        repo = "alternative-toolbar";
        rev = "v${version}";
        sha256 = "sha256-8bNCVGuRK2ZTlG3yrQeJF+gg9K8lthvIVnw3Gk1CBaQ=";
    };

    nativeBuildInputs = [ pkg-config which intltool glib gst_all_1.gstreamer gst_all_1.gst-plugins-base gtk3 libpeas gobject-introspection autoconf automake python3 python3.pkgs.pygobject3 rhythmbox ];

    buildPhase = ''
        ./autogen.sh --prefix=$out
        make
        make install
    '';

    # # package needs more work done to integrate with rhythmbox: 
    # # - not sure how to join the $out of this package with the main rhythmbox one or link the relevant things to the home folder.
    #
    # installPhase = ''
    # '';
}