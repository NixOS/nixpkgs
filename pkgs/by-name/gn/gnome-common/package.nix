{
  lib,
  stdenv,
  fetchurl,
  which,
  gnome,
  autoconf,
  automake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-common";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-common/${lib.versions.majorMinor finalAttrs.version}/gnome-common-${finalAttrs.version}.tar.xz";
    hash = "sha256-IlaeNwrnVeBFJ7djKL78THO2K/1KVySZ/eEWuDGK+M8=";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-common"; };
  };

  propagatedBuildInputs = [
    which
    autoconf
    automake
  ]; # autogen.sh which is using gnome-common tends to require which

  meta = {
    teams = [ lib.teams.gnome ];
  };
})
