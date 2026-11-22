{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook269,
  neon,
  po4a,
  procps,
  replaceVars,
  zlib,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "davfs2";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "alisarctl";
    repo = "davfs2";
    tag = "rel-${lib.replaceString "." "-" finalAttrs.version}";
    hash = "sha256-ZKHqrQwaCByMA3msOe+V6+0SWIMF64GW3SGlp9HfYyk=";
  };

  nativeBuildInputs = [
    autoreconfHook269
    po4a
  ];

  buildInputs = [
    zlib
  ];

  patches = [
    ./fix-sysconfdir.patch
    ./disable-suid.patch
    (replaceVars ./0001-umount_davfs-substitute-ps-command.patch {
      ps = "${procps}/bin/ps";
    })
    (replaceVars ./0002-Make-sure-that-the-setuid-wrapped-umount-is-invoked.patch {
      inherit wrapperDir;
    })
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-neon=${lib.getLib neon}"
  ];

  postConfigure = ''
    (cd man && po4a po4a.conf)
  '';

  meta = {
    homepage = "https://github.com/alisarctl/davfs2";
    description = "Mount WebDAV shares like a typical filesystem";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Web Distributed Authoring and Versioning (WebDAV), an extension to
      the HTTP-protocol, allows authoring of resources on a remote web
      server. davfs2 provides the ability to access such resources like
      a typical filesystem, allowing for use by standard applications
      with no built-in support for WebDAV.
    '';

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
