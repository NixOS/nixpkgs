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
, signify
, overrideSDK
, withSsh ? true, openssh
# Default editor to use when neither VISUAL nor EDITOR are defined
, defaultEditor ? null
}:

let
  stdenv' = if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
    then overrideSDK stdenv "11.0"
    else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "got";
  version = "0.106";

  src = fetchurl {
    url = "https://gameoftrees.org/releases/portable/got-portable-${finalAttrs.version}.tar.gz";
    hash = "sha256-MHnXQsElBH3jOd2SPXXQuWCZWjpLVn7QjvNtESvbB8w=";
  };

  nativeBuildInputs = [ pkg-config bison ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ libressl libbsd libevent libuuid libmd zlib ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libossp_uuid ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The configure script assumes dependencies on Darwin are installed via
    # Homebrew or MacPorts and hardcodes assumptions about the paths of
    # dependencies which fails the nixpkgs configurePhase.
    substituteInPlace configure --replace-fail 'xdarwin' 'xhomebrew'
  '';

  env.NIX_CFLAGS_COMPILE = toString (
  lib.optionals (defaultEditor != null) [
    ''-DGOT_DEFAULT_EDITOR="${lib.getExe defaultEditor}"''
  ] ++ lib.optionals withSsh [
    ''-DGOT_DIAL_PATH_SSH="${lib.getExe openssh}"''
    ''-DGOT_TAG_PATH_SSH_KEYGEN="${lib.getExe' openssh "ssh-keygen"}"''
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    ''-DGOT_TAG_PATH_SIGNIFY="${lib.getExe signify}"''
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=int-conversion"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
