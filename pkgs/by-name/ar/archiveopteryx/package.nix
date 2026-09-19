{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  perl,
  zlib,
  jam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "archiveopteryx";
  version = "3.2.0-unstable-2026-04-29";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aox";
    repo = "aox";
    rev = "1f9a987ab63808c72dd9e400ddcdc3c1601a157a";
    hash = "sha256-LEILJARkRlEkV7g7JIemB00a7HIiYoKMcugRZOpmtGk=";
  };

  nativeBuildInputs = [
    jam
    perl
  ];

  buildInputs = [
    openssl
    zlib
  ];

  env = {
    INSTALLROOT = placeholder "out";
  };

  postPatch = ''
    substituteInPlace server/tlsthread.cpp \
      --replace-fail 'SSLv23_server_method()' 'TLS_server_method()'

    substituteInPlace Jamsettings \
      --replace-fail 'BINDIR = $(PREFIX)/bin' 'BINDIR = '"$out"'/bin' \
      --replace-fail 'SBINDIR = $(PREFIX)/sbin' 'SBINDIR = '"$out"'/bin' \
      --replace-fail 'LIBDIR = $(PREFIX)/lib' 'LIBDIR = '"$out"'/lib' \
      --replace-fail 'PIDFILEDIR ?= $(PREFIX)/lib/pidfiles' 'PIDFILEDIR ?= /run/archiveopteryx' \
      --replace-fail 'JAILDIR = $(PREFIX)/jail' 'JAILDIR = /var/lib/archiveopteryx/jail' \
      --replace-fail 'MESSAGEDIR = $(JAILDIR)/messages' 'MESSAGEDIR = /var/lib/archiveopteryx/jail/messages' \
      --replace-fail 'CONFIGDIR = $(PREFIX)' 'CONFIGDIR = /etc/archiveopteryx' \
      --replace-fail 'MANDIR = $(PREFIX)/man' 'MANDIR = '"$out"'/share/man' \
      --replace-fail 'READMEDIR = $(PREFIX)' 'READMEDIR = '"$out"'/share/doc/archiveopteryx'
  '';

  # c++17+ fails; newer GCCs also promote a few legacy warnings to errors.
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-std=c++11"
      "-Wno-error=builtin-declaration-mismatch"
      "-Wno-error=deprecated-copy"
      "-Wno-error=implicit-fallthrough"
      "-Wno-error=nonnull"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
      "-Wno-error=mismatched-new-delete"
    ]
  );

  buildPhase = ''
    runHook preBuild

    jam "-j$NIX_BUILD_CORES"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    jam install

    runHook postInstall
  '';

  meta = {
    description = "Advanced PostgreSQL-based IMAP and POP server";
    longDescription = ''
      Archiveopteryx is a mail server with IMAP, POP, LMTP, and related
      administration tooling built around a PostgreSQL-backed message store.
    '';
    changelog = "https://github.com/aox/aox/commit/${finalAttrs.src.rev}";
    homepage = "http://archiveopteryx.org/";
    license = lib.licenses.postgresql;
    mainProgram = "aox";
    maintainers = [ lib.maintainers.philocalyst ];
    platforms = lib.platforms.linux;
  };
})
