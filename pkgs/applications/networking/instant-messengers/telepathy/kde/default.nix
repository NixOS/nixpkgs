{ stdenv, fetchurl, fetchgit, telepathy_qt, kdelibs, kde_workspace, gettext, dbus_libs, farstream
, pkgconfigUpstream , qt_gstreamer1, telepathy_glib, telepathy_logger, qjson, flex, bison, qca2 }:

let
  pkgconfig = pkgconfigUpstream;
  version = "0.8.80";
  manifest = import (./. + "/${version}.nix");

  overrides = {
    telepathy_logger_qt = x : x // {
      NIX_CFLAGS_COMPILE = "-I${dbus_libs}/include/dbus-1.0";
    };
  };

  extraBuildInputs = {
    auth_handler = [ qjson qca2 ];
    call_ui = [ qt_gstreamer1 telepathy_glib farstream ];
    contact_applet = [ kde_workspace ];
    telepathy_logger_qt = [ telepathy_logger qt_gstreamer1 ];
    text_ui = [ qt_gstreamer1 telepathy_logger qjson ];
    common_internals = [ telepathy_qt ];
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
