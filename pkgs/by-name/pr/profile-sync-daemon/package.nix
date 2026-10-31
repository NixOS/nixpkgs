{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profile-sync-daemon";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-sync-daemon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J1O7pXV8p0ho8uqws/AjrTTY5BB8jme3lVsngmh5TTA=";
  };

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    substituteInPlace $out/bin/profile-sync-daemon \
      --replace-fail "/usr/" "$out/" \
      --replace-fail "sudo " "/run/wrappers/bin/sudo "
    # $HOME detection fails (and is unnecessary)
    sed -i '/^HOME/d' $out/bin/profile-sync-daemon
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
