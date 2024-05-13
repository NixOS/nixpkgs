{ lib
, stdenv
, fetchurl
, pkg-config
, libressl
, libbsd
, libevent
, libuuid
, libossp_uuid
, libmd
, zlib
, ncurses
, bison
, autoPatchelfHook
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "got";
  version = "0.99";

  src = fetchurl {
    url = "https://gameoftrees.org/releases/portable/got-portable-${finalAttrs.version}.tar.gz";
    hash = "sha256-rqQINToCsuOtm00bdgeQAmmvl5htQJmMV/EKzfD6Hjg=";
  };

  nativeBuildInputs = [ pkg-config bison ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [ libressl libbsd libevent libuuid libmd zlib ncurses ]
    ++ lib.optionals stdenv.isDarwin [ libossp_uuid ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    # The configure script assumes dependencies on Darwin are installed via
    # Homebrew or MacPorts and hardcodes assumptions about the paths of
    # dependencies which fails the nixpkgs configurePhase.
    substituteInPlace configure --replace-fail 'xdarwin' 'xhomebrew'
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    # error: conflicting types for 'strmode'
    "-DHAVE_STRMODE=1"
    # Undefined symbols for architecture arm64: "_bsd_getopt"
    "-include getopt.h"
  ]);

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://gameoftrees.org/releases/CHANGES";
    description = "Version control system which prioritizes ease of use and simplicity over flexibility";
    longDescription = ''
      Game of Trees (Got) is a version control system which prioritizes
      ease of use and simplicity over flexibility.

      Got uses Git repositories to store versioned data. Git can be used
      for any functionality which has not yet been implemented in
      Got. It will always remain possible to work with both Got and Git
      on the same repository.
    '';
    homepage = "https://gameoftrees.org";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ abbe afh ];
    mainProgram = "got";
    platforms = with lib.platforms; darwin ++ linux;
  };
})
