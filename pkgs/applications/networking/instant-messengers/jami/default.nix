{ stdenv
, lib
, callPackage
, fetchzip
, jack
, udev
, qt6Packages
}:

let
  version = "20220503.1550.0f35faa";

  src = fetchzip {
    url = "https://dl.jami.net/release/tarballs/jami_${version}.tar.gz";
    hash = "sha256-iCmsgjgGogNjj1k0sYRqx59ZEwFZcJOeVGBNyBlcy1M=";

    stripRoot = false;
    postFetch = ''
      cd $out
      mv jami-project/* ./
      rm -r jami-project.rst jami-project client-android client-ios client-macosx client-uwp
      rm daemon/contrib/tarballs/*
    '';
  };

  jami-meta = with lib; {
    homepage = "https://jami.net/";
    description = " for Jami, the free and universal communication platform that respects the privacy and freedoms of its users";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.linsui ];
  };
in
rec {
  jami-daemon = callPackage ./daemon.nix { inherit version src udev jack jami-meta; };

  jami-libclient = qt6Packages.callPackage ./libclient.nix { inherit version src jami-meta; };

  jami-client-qt = qt6Packages.callPackage ./client-qt.nix { inherit version src jami-meta; };
}
