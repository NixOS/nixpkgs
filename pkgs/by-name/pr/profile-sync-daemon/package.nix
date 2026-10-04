{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  rsync,
  kmod,
  gawk,
  glib,
  fuse-overlayfs,
  fuse3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "profile-sync-daemon";
  version = "7.04";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-sync-daemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G2w5V9Eq19Jjx7PZcKH8bBZ3tOoghYaPQyMjlwFkARY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "PREFIX=$(out)"
    "INITDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  postInstall = ''
    substituteInPlace \
      $out/bin/{profile-sync-daemon,psd-suspend-sync} \
      $out/lib/systemd/user/psd{.service,-resync.service} \
      --replace-fail /usr $out

    for f in $out/bin/*; do
      if [ ! -L "$f" ]; then
        wrapProgram $f --prefix PATH : ${
          lib.makeBinPath [
            rsync
            kmod
            gawk
            glib
            fuse-overlayfs
            fuse3
          ]
        }
      fi
    done
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
