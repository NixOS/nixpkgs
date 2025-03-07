{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pam,
}:

stdenv.mkDerivation rec {
  pname = "pam_tmpdir";
  version = "0.09";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/p/pam-tmpdir/pam-tmpdir_${version}.tar.gz";
    hash = "sha256-MXa1CY6alD83E/Q+MJmsv8NaImWd0pPJKZd/7nbe4J8=";
  };

  postPatch = ''
    substituteInPlace pam_tmpdir.c \
      --replace /sbin/pam-tmpdir-helper $out/sbin/pam-tmpdir-helper

    # chmod/chown fails on files in /nix/store
    sed -i -E -e '/^\s*(chmod|chown)/d' Makefile.{am,in}

    # the symlinks in m4 assume FHS
    rm -rf m4
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ pam ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://tracker.debian.org/pkg/pam-tmpdir";
    description = "PAM module for creating safe per-user temporary directories";
    mainProgram = "pam-tmpdir-helper";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
