{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libgcrypt,
  zlib,
  bzip2,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "munge";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "munge-${finalAttrs.version}";
    sha256 = "sha256-fv42RMUAP8Os33/iHXr70i5Pt2JWZK71DN5vFI3q7Ak=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt # provides libgcrypt.m4
  ];

  buildInputs = [
    libgcrypt
    zlib
    bzip2
  ];

  strictDeps = true;

  configureFlags = [
    # Load data from proper global paths
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--runstatedir=/run"
    "--with-sysconfigdir=/etc/default"

    # Install data to proper directories
    "--with-pkgconfigdir=${placeholder "out"}/lib/pkgconfig"
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"

    # Cross-compilation hacks
    "--with-libgcrypt-prefix=${lib.getDev libgcrypt}"
    # workaround for cross compilation: https://github.com/dun/munge/issues/103
    "ac_cv_file__dev_spx=no"
    "x_ac_cv_check_fifo_recvfd=no"
  ];

  installFlags = [
    "localstatedir=${placeholder "out"}/var"
    "runstatedir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
    "sysconfigdir=${placeholder "out"}/etc/default"
  ];

  postInstall = ''
    # rmdir will notify us if anything new is installed to the directories.
    rmdir "$out"/{var{/{lib,log}{/munge,},},etc/munge}
  '';

  passthru.tests.nixos = nixosTests.munge;

  meta = with lib; {
    description = ''
      An authentication service for creating and validating credentials
    '';
    license = [
      # MUNGE
      licenses.gpl3Plus
      # libmunge
      licenses.lgpl3Plus
    ];
    platforms = platforms.unix;
    maintainers = [ maintainers.rickynils ];
  };
})
