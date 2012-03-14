{ stdenv, fetchurl, telepathy_qt, kdelibs, gettext, pkgconfig }:

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

  pkgs = builtins.listToAttrs (map ktpFun manifest);
  common_internals = pkgs.common_internals;
in
pkgs //{
  inherit version;
  recurseForDerivations = true;
  full = stdenv.lib.attrValues pkgs;
}
