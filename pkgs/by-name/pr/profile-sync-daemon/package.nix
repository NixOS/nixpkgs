{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  coreutils,
  glib,
  procps,
}:

stdenv.mkDerivation rec {
  pname = "profile-sync-daemon";
  version = "6.50";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-sync-daemon";
    rev = "v${version}";
    hash = "sha256-Wb9YLxuu9i9s/Y6trz5NZDU9WRywe3138cp5Q2gWbxM=";
  };

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    substituteInPlace $out/bin/profile-sync-daemon \
      --replace "/usr/" "$out/" \
      --replace "sudo " "/run/wrappers/bin/sudo " \
      --replace "gdbus" "${glib}/bin/gdbus" \
      --replace " psd-overlay-helper" " $out/bin/psd-overlay-helper" \
      --replace "pkill" "${procps}/bin/pkill" \
      --replace "pgrep" "${procps}/bin/pgrep"
    # $HOME detection fails (and is unnecessary)
    sed -i '/^HOME/d' $out/bin/profile-sync-daemon
    substituteInPlace $out/bin/psd-overlay-helper \
      --replace "PATH=/usr/bin:/bin" "PATH=${util-linux.bin}/bin:${coreutils}/bin" \
      --replace "sudo " "/run/wrappers/bin/sudo "
    substituteInPlace $out/bin/psd-suspend-sync \
      --replace "/usr" "$out" \
      --replace "gdbus" "${glib}/bin/gdbus"
  '';

  meta = with lib; {
    description = "Syncs browser profile dirs to RAM";
    longDescription = ''
      Profile-sync-daemon (psd) is a tiny pseudo-daemon designed to manage your
      browser's profile in tmpfs and to periodically sync it back to your
      physical disc (HDD/SSD). This is accomplished via a symlinking step and
      an innovative use of rsync to maintain back-up and synchronization
      between the two. One of the major design goals of psd is a completely
      transparent user experience.
    '';
    homepage = "https://github.com/graysky2/profile-sync-daemon";
    downloadPage = "https://github.com/graysky2/profile-sync-daemon/releases";
    license = licenses.mit;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}
