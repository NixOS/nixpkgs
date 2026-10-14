{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_tmpdir";
  version = "0.11";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/p/pam-tmpdir/pam-tmpdir_${finalAttrs.version}.tar.gz";
    hash = "sha256-SuMOKSsQ68zJBhhFi+5hgt3nkus73mh8jMPZhmMkzfM=";
  };

  postPatch = ''
    substituteInPlace pam_tmpdir.c \
      --replace-fail '/usr/libexec/pam-tmpdir/pam-tmpdir-helper' "$out/libexec/pam-tmpdir/pam-tmpdir-helper"

    # chmod/chown fails on files in /nix/store
    sed -i -E -e '/^\s*(chmod|chown)/d' Makefile.am

    # the symlinks in m4 assume FHS
    rm -rf m4
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ pam ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://tracker.debian.org/pkg/pam-tmpdir";
    description = "PAM module for creating safe per-user temporary directories";
    mainProgram = "pam-tmpdir-helper";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
})
