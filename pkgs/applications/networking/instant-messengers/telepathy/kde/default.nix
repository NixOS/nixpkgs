{ stdenv, fetchurl, fetchgit, telepathy_qt, kdelibs, kde_workspace, gettext, dbus_libs
, pkgconfigUpstream , qt_gstreamer, telepathy_glib, telepathy_logger, qjson, flex, bison }:

let
  pkgconfig = pkgconfigUpstream;
  version = "0.4.0";
  manifest = import (./. + "/${version}.nix");

  overrides = {
    telepathy_logger_qt = x : x // {
      NIX_CFLAGS_COMPILE = "-I${dbus_libs}/include/dbus-1.0";
    };
  };

  extraBuildInputs = {
    auth_handler = [ qjson ];
    call_ui = [ qt_gstreamer telepathy_glib ];
    contact_applet = [ kde_workspace ];
    telepathy_logger_qt = [ telepathy_logger qt_gstreamer ];
    text_ui = [ ktp.telepathy_logger_qt qt_gstreamer telepathy_logger ];
  };

  extraNativeBuildInputs = {
    telepathy_logger_qt = [ flex bison ];
  };

  ktpFun = { name, key, sha256 }:
  {
    name = key;
    value = stdenv.mkDerivation (
      (stdenv.lib.attrByPath [ key ] (x : x) overrides)
      {
        name = "${name}-${version}";

        src = fetchurl {
          url = "mirror://kde/unstable/kde-telepathy/${version}/src/${name}-${version}.tar.bz2";
          inherit sha256;
        };

        nativeBuildInputs = [ gettext pkgconfig ] ++ (stdenv.lib.attrByPath [ key ] [] extraNativeBuildInputs);
        buildInputs = [ kdelibs telepathy_qt ]
          ++ stdenv.lib.optional (name != "ktp-common-internals") ktp.common_internals
          ++ (stdenv.lib.attrByPath [ key ] [] extraBuildInputs);

        meta = {
          inherit (kdelibs.meta) platforms;
          maintainers = [ stdenv.lib.maintainers.urkud ];
        };
      }
    );
  };

  ktp = builtins.listToAttrs (map ktpFun manifest);
in
ktp // {
  inherit version;
  recurseForDerivations = true;
  full = stdenv.lib.attrValues ktp;
}
