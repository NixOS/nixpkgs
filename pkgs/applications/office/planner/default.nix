{ newScope, stdenv }:

let
  callPackage = newScope stdenv;

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Planner";
    description = "Project management application for GNOME";
    license = licenses.gpl2Plus;
  };
in
  {
    stable = callPackage ./stable.nix { basicmeta = meta; };

    unstable = callPackage ./unstable.nix { basicmeta = meta; };

    unofficial = callPackage ./unofficial.nix { basicmeta = meta; };
  }
