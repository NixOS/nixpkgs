{
  stdenv,
  lib,
  fetchFromGitHub,
  libcap,
  libsodium,
  openssl,
  zlib,
  perl,
  ncurses,
  libxcrypt-legacy,
  removeReferencesTo,
}:

let
  perl' = perl.override {
    libxcrypt = libxcrypt-legacy;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proftpd";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "proftpd";
    repo = "proftpd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Iyzk0OctTvDDkYXPDSrvaWQOjkbBXHY7ELyhkUx/X0=";
  };

  patches = [ ./no-install-user.patch ];

  strictDeps = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    libcap
    libsodium
    openssl
    zlib
    perl'
    ncurses
  ];

  nativeBuildInputs = [ removeReferencesTo ];

  configureFlags = [
    "--enable-openssl"
    "--with-modules=mod_sftp"
  ];

  postInstall = ''
    patchShebangs $out/bin

    # This causes a cyclic dependency between $out and $dev, but for
    # no good reason: `--enable-dso` is disabled, so this isn't functional
    # and even then we'd need special support for building custom proftpd
    # modules since installing stuff into the store later on
    # doesn't work anyways.
    rm $out/bin/prxs

    # Remove unneeded directories:
    # * var doesn't make sense in the store
    # * share/locale is not used
    # * libexec seems to be needed for custom modules
    #   only which is not supported by this package.
    rm -r $out/{var,share,libexec}
  '';

  postFixup = ''
    # Strip away configure flags from proftpd that point to $dev.
    remove-references-to -t $dev $out/bin/*
  '';

  meta = {
    homepage = "http://www.proftpd.org/";
    teams = [ lib.teams.flyingcircus ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "proftpd";
    platforms = lib.platforms.unix;
    changelog = "http://proftpd.org/docs/RELEASE_NOTES-${finalAttrs.version}";
    description = "Highly configurable GPL-licensed FTP server software";
  };
})
