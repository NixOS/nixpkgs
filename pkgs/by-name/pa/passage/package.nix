{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  replaceVars,
  pass,
  passage,
  age,
  unixtools,
  coreutils,
  findutils,
  gnugrep,
  gnused,
  qrencode ? null,
  wl-clipboard ? null,
  git ? null,
  xclip ? null,
  # Used to pretty-print list of all stored passwords, but is not needed to fetch
  # or store password by its name. Most users would want this dependency.
  tree ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passage";
  version = "1.7.4a2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "passage";
    rev = "${finalAttrs.version}";
    hash = "sha256-tGHJFzDc2K117r5EMFdKsfw/+EpdZ0qzaExt+RGI4qo=";
  };

  patches = [
    (replaceVars ./darwin-getopt-path.patch {
      getopt = unixtools.getopt;
    })
    ./set-correct-program-name-for-sleep.patch
  ];
  postPatch = ''
    # Since we reuse the pass wrapper the extension will also live in its directory not the passage specific one
    substituteInPlace Makefile \
      --replace-fail 's:^SYSTEM_EXTENSION_DIR=.*:SYSTEM_EXTENSION_DIR="$(LIBDIR)/passage/extensions":' "" \
      --replace-fail '"$(DESTDIR)$(LIBDIR)/passage' '"$(DESTDIR)$(LIBDIR)/password-store'
    substituteInPlace src/password-store.sh \
      --replace-fail 'SYSTEM_EXTENSION_DIR=""' 'SYSTEM_EXTENSION_DIR="''${SYSTEM_EXTENSION_DIR:-${placeholder "out"}/lib/password-store/extensions}"'
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  extraPath = lib.makeBinPath (
    [
      age
      coreutils
      findutils
      unixtools.getopt
      git
      gnugrep
      gnused
      qrencode
      tree
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      wl-clipboard
      xclip
    ]
  );

  # Using $0 is bad, it causes --help to mention ".passage-wrapped".
  postInstall = ''
    substituteInPlace $out/bin/passage \
              --replace-fail 'AGE="''${PASSAGE_AGE:-age}"' 'AGE=${lib.getExe age}' \
              --replace-fail 'PROGRAM="''${0##*/}"' 'PROGRAM=passage'
    wrapProgram $out/bin/passage --prefix PATH : $extraPath --argv0 $pname
  '';

  installFlags = [
    "PREFIX=$(out)"
    "WITH_ALLCOMP=yes"
  ];
  passthru = {
    withExtensions = pass.withExtensions.override { pass = passage; };
  };

  meta = {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://github.com/FiloSottile/passage";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      kaction
      ma27
    ];
    platforms = lib.platforms.unix;
    mainProgram = "passage";

    longDescription = ''
      passage is a fork of password-store (https://www.passwordstore.org) that uses
      age (https://age-encryption.org) as a backend instead of GnuPG.

      It keeps passwords inside age(1) encrypted files inside a simple
      directory tree and provides a series of commands for manipulating the
      password store, allowing the user to add, remove, edit and synchronize
      passwords.
    '';
  };
})
