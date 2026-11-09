{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  findutils,
  fuse3,
  fuse-overlayfs,
  glib,
  kmod,
  rsync,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profile-sync-daemon";
  version = "7.04";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-sync-daemon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G2w5V9Eq19Jjx7PZcKH8bBZ3tOoghYaPQyMjlwFkARY=";
  };

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    patchShebangs $out/bin/profile-sync-daemon
    patchShebangs $out/bin/psd-suspend-sync

    substituteInPlace $out/bin/profile-sync-daemon \
      --replace "PATH=\$PATH:/sbin" \
      "PATH=\$PATH:$out:${coreutils}/bin:${findutils}/bin:${fuse3}/bin:${fuse-overlayfs}/bin:${glib}/bin:${kmod}/bin:${rsync}/bin:${systemd}/bin" \
      --replace "/usr/" "$out/" \
      --replace "sudo " "/run/wrappers/bin/sudo "
    # $HOME detection fails (and is unnecessary)
    sed -i '/^HOME/d' $out/bin/profile-sync-daemon
    substituteInPlace $out/bin/psd-suspend-sync \
      --replace "/usr/bin" "$out/bin" \
      --replace "gdbus monitor" "${glib}/bin/gdbus monitor" \
      --replace "systemd-inhibit" "${systemd}/bin/systemd-inhibit"
  '';

  meta = {
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
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.prikhi ];
    platforms = lib.platforms.linux;
  };
})
