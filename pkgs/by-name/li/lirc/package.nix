{
  lib,
  stdenv,
  fetchgit,
  fetchurl,
  buildPackages,
  autoreconfHook,
  pkg-config,
  help2man,
  python3,
  linuxHeaders,

  alsa-lib,
  libxslt,
  systemd,
  libusb-compat-0_1,
  libftdi1,
  libice,
  libsm,
  libx11,
  runtimeShellPackage,
}:

let
  pythonBuildEnv = python3.pythonOnBuildForHost.withPackages (
    p: with p; [
      setuptools
    ]
  );
  pythonHostEnv = python3.withPackages (
    p: with p; [
      pyyaml
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lirc";
  version = "0.10.2-unstable-2026-06-07";

  src = fetchgit {
    url = "https://git.code.sf.net/p/lirc/git";
    rev = "b0f06cbf027fa767d5456311d9195803167290f5";
    hash = "sha256-i4acp2htuaR0mTOI8oZ6NWf0NUESxJZVI5Z+cRX9Cfw=";
  };

  postPatch = ''
    patchShebangs tools/lirc-make-devinput tools/irdb-get doc/
    substituteInPlace systemd/*.service \
      --replace-fail "ExecStart=/usr/" "ExecStart=''${!outputBin}/"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    help2man
    libxslt
    pythonBuildEnv
    pkg-config
  ];

  buildInputs = [
    runtimeShellPackage
    pythonHostEnv
    alsa-lib
    systemd
    libusb-compat-0_1
    libftdi1
    libice
    libsm
    libx11
  ];

  env.DEVINPUT_HEADER = "${linuxHeaders}/include/linux/input-event-codes.h";
  env.LIRC_REMOTES_LIST =
    "file://"
    + (fetchurl {
      name = "lirc-remotes.list";
      url = "http://lirc-remotes.sourceforge.net/remotes.list";
      hash = "sha256-TVkV19ApWiupiHEyBldaiDuJDc9k0uZzP5UKuuYplfU=";
    });

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--enable-uinput" # explicit activation because build env has no uinput
    "--enable-devinput" # explicit activation because build env has no /dev/input
    "--with-lockdir=/run/lirc/lock" # /run/lock is not writable for 'lirc' user
    # So $out/bin/irexec will use the host platform's runtimeShell
    "SH_PATH=${lib.getExe runtimeShellPackage}"
  ];

  installFlags = [
    "sysconfdir=$out/etc"
    "localstatedir=$TMPDIR"
  ];

  outputs = [
    "out"
    "man"
    "doc"
    "dev"
    # This is the output referenced by dependent packages most of the time.
    # $out on the other hand contains files used by direct users of lirc -
    # systemd units, binaries, shell scripts & lirc python package. Since
    # Nixpkgs' stdenv puts by default python libraries in $lib, this causes a
    # cyclic reference between $out and $lib. We solve this by moving the
    # Python library to $out in postFixup below. Since the Python library is
    # also strongly related to the direct usage of lirc (and not only linking
    # to the libraries of it), this makes sense anyway.
    "lib"
  ];

  postFixup = ''
    moveToOutput "${python3.sitePackages}" "$out"
  ''
  # $out/bin/lirc-setup is symlinked to $lib/''${python3.sitePackages}, so it
  # has to be fixed due to the above.
  + ''
    rm $out/bin/lirc-setup
    ln -s $out/${python3.sitePackages}/lirc-setup/lirc-setup $out/bin/lirc-setup
  ''
  # Fix the shebangs of scripts used during build and also distributed for
  # the host to use.
  + ''
    patchShebangs --host --update \
      ''${!outputBin}/bin/{lirc-make-devinput,irdb-get}
  ''
  # This script is used during build, and its shebang is patched during
  # postPatch above. Upstream's doc/Makefile.am lists it as a _DATA file so it
  # doesn't get the executable bit when installed. We don't make it an
  # executable so `patchShebangs --host --update` will patch it too, as it is
  # meant for imperative installations, where external drivers and their docs
  # might be added by another package and the package manager regenerates the
  # table of contents. This is not relevant for Nix because packages' outputs
  # cannot be altered by other packages.
  + ''
    rm ''${!outputDoc}/share/doc/lirc/plugindocs/make-ext-driver-toc.sh
  '';
  # Avoid retaining references to buildPlatform's interpreters that are used
  # during build, but should not be part of $out. See fixes above in
  # `postFixup`.
  disallowedReferences =
    lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform)
      [
        buildPackages.runtimeShellPackage
        buildPackages.python3
      ];

  # Upstream ships broken symlinks in docs
  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Allows to receive and send infrared signals";
    homepage = "https://www.lirc.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pSub
      doronbehar
    ];
  };
})
