{ stdenv
, lib
, callPackage
, fetchzip
, jack
, udev
, libsForQt5
}:

rec {
  version = "20211223.2.37be4c3";

  src = fetchzip {
    url = "https://dl.jami.net/release/tarballs/jami_${version}.tar.gz";
    sha256 = "1zw9azwmxr4991nq5kl527lbwlj7psrissgvrkl1kxxbfbdncbhh";

    stripRoot = false;
    extraPostFetch = ''
      cd $out
      mv ring-project/* ./
      rm -r ring-project.rst ring-project client-android client-ios client-macosx client-uwp
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

  jami-daemon = callPackage ./daemon.nix { inherit version src udev jack jami-meta; };

  jami-libclient = libsForQt5.callPackage ./libclient.nix { inherit version src jami-meta; };

  jami-client-gnome = libsForQt5.callPackage ./client-gnome.nix { inherit version src jami-meta; };

  jami-client-qt = libsForQt5.callPackage ./client-qt.nix { inherit version src jami-meta; };
}
