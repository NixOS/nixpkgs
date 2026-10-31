{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
  fuse-overlayfs,
  runCommand,
  writableTmpDirAsHomeHook,
  makeWrapper,
  coreutils,
  rsync,
  kmod,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "profile-sync-daemon";
  version = "7.00";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-sync-daemon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XlpKHU+TvTxDGvpfr4wRV4GsVyVmxEKQ7J4Ac2sqybo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    substituteInPlace $out/bin/profile-sync-daemon \
      --replace-fail "/usr/bin/fuse-overlayfs" "${fuse-overlayfs}/bin/fuse-overlayfs" \
      --replace-fail "/usr/share/" "$out/share/" \
      --replace-fail "sudo " "/run/wrappers/bin/sudo "
    # $HOME detection fails (and is unnecessary)
    sed -i '/^HOME/d' $out/bin/profile-sync-daemon
    wrapProgram $out/bin/profile-sync-daemon \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          rsync
          kmod
        ]
      }
  '';

  passthru.tests.simple =
    runCommand "profile-sync-daemon preview"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          writableTmpDirAsHomeHook
        ];
      }
      ''
        # The script tells you to modify your config and to run again.
        profile-sync-daemon preview
        profile-sync-daemon preview

        touch $out
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
