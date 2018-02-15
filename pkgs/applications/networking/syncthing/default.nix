{ stdenv, lib, pkgs, go, procps, removeReferencesTo }:

let
  common = import ./common.nix {
    inherit pkgs;
  };

in stdenv.mkDerivation rec {
  inherit (common) version src buildInputs preFixup meta;

  name = "syncthing-${version}";
  buildPhase = common.makeBuildPhase "syncthing";

  installPhase = ''
    mkdir -p $out/lib/systemd/{system,user}

    install -Dm755 syncthing $out/bin/syncthing

    # This installs man pages in the correct directory according to the suffix
    # on the filename
    for mf in man/*.[1-9]; do
      mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
      mandir="$out/share/man/man$mantype"
      mkdir -p "$mandir"
      install -Dm644 "$mf" "$mandir/$(basename "$mf")"
    done

  '' + lib.optionalString (stdenv.isLinux) ''
    substitute etc/linux-systemd/system/syncthing-resume.service \
               $out/lib/systemd/system/syncthing-resume.service \
               --replace /usr/bin/pkill ${procps}/bin/pkill

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/lib/systemd/system/syncthing@.service \
               --replace /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/lib/systemd/user/syncthing.service \
               --replace /usr/bin/syncthing $out/bin/syncthing
  '';
}
