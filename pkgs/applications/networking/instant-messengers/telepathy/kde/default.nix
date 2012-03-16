{ stdenv, fetchurl, fetchgit, telepathy_qt, kdelibs, gettext, pkgconfig
, qt_gstreamer }:

let
  version = "0.3.0";
  manifest = import (./. + "/${version}.nix");
  overrides = {
    presence_applet = x : (x // { patches = [ ./presence-applet-po.patch ]; });
    contact_applet = x: (x // { patches = [ ./contact-applet-po.patch ]; });
  };
  ktpFun = { name, key, sha256 }:
  {
    name = key;
    value = stdenv.mkDerivation (
      (if builtins.hasAttr key overrides then builtins.getAttr key overrides else (x: x))
      {
        name = "${name}-${version}";

        src = fetchurl {
          url = "mirror://kde/unstable/kde-telepathy/${version}/src/${name}-${version}.tar.bz2";
          inherit sha256;
        };

        buildNativeInputs = [ gettext pkgconfig ];
        buildInputs = [ kdelibs telepathy_qt ]
          ++ stdenv.lib.optional (name != "ktp-common-internals") common_internals;
      }
    );
  };

  stable = builtins.listToAttrs (map ktpFun manifest);
  unstable = {
    call_ui = stdenv.mkDerivation {
      name = "ktp-call-ui-20120314";

      src = fetchgit {
        url = git://anongit.kde.org/ktp-call-ui;
        rev = "3587166d1ace83b115e113853514a7acc04d9d86";
        sha256 = "0yv386rqy4vkwmd38wvvsrbam59sbv5k2lwimv96kf93xgkp5g0l";
      };

      buildInputs = [ kdelibs telepathy_qt common_internals qt_gstreamer ];
      buildNativeInputs = [ gettext pkgconfig ];
    };
  };
  common_internals = pkgs.common_internals;
  pkgs = unstable // stable;
in
pkgs // {
  inherit version;
  recurseForDerivations = true;
  full = stdenv.lib.attrValues stable;
}
