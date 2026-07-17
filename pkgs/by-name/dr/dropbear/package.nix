{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libxcrypt,
  enableSCP ? false,
  sftpPath ? "/run/current-system/sw/libexec/sftp-server",
}:

let
  # NOTE: DROPBEAR_PATH_SSH_PROGRAM is only necessary when enableSCP is true,
  # but it is enabled here always anyways for consistency
  dflags = {
    SFTPSERVER_PATH = sftpPath;
    DROPBEAR_PATH_SSH_PROGRAM = "${placeholder "out"}/bin/dbclient";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dropbear";
  version = "2026.92";

  src = fetchFromGitHub {
    owner = "mkj";
    repo = "dropbear";
    tag = "DROPBEAR_${finalAttrs.version}";
    hash = "sha256-xXjKWj6tMW/Qlq4DttxKAqOwsER2QEeb1Qw3Gllu2QQ=";
  };

  patches = [
    # Allow sessions to inherit the PATH from the parent dropbear.
    # Otherwise they only get the usual /bin:/usr/bin kind of PATH
    ./pass-path.patch
  ];

  env.CFLAGS = lib.pipe (lib.attrNames dflags) [
    (map (name: "-D${name}=\\\"${dflags.${name}}\\\""))
    (lib.concatStringsSep " ")
  ];

  configureFlags = lib.optionals stdenv.hostPlatform.isMusl [
    "--enable-wtmp=no"
    "--enable-wtmpx=no"
  ];

  # https://www.gnu.org/software/make/manual/html_node/Libraries_002fSearch.html
  preConfigure = ''
    makeFlagsArray=(
      VPATH=$(cat $NIX_CC/nix-support/orig-libc)/lib
      PROGRAMS="${
        lib.concatStringsSep " " (
          [
            "dropbear"
            "dbclient"
            "dropbearkey"
            "dropbearconvert"
          ]
          ++ lib.optionals enableSCP [ "scp" ]
        )
      }"
    )
  '';

  buildInputs = [
    zlib
    libxcrypt
  ];

  postInstall = lib.optionalString enableSCP ''
    ln -rs $out/bin/scp $out/bin/dbscp
  '';

  meta = {
    description = "Small memory footprint ssh server/client suitable for memory-constrained environments";
    longDescription = ''
      Dropbear is particularly useful for "embedded"-type Linux (or other Unix) systems, such as wireless routers.

      ## Features

      * Implements X11 forwarding, and authentication-agent forwarding for OpenSSH clients
      * Can run from inetd or standalone
      * Compatible with OpenSSH ~/.ssh/authorized_keys public key authentication
      * Multi-hop mode uses SSH TCP forwarding to tunnel through multiple SSH hosts in a single command:

      ```shell
      dbclient user1@hop1,user2@hop2,destination
      ```
    '';
    homepage = "https://matt.ucc.asn.au/dropbear/dropbear.html";
    changelog = "https://github.com/mkj/dropbear/releases/tag/DROPBEAR_${finalAttrs.version}";
    downloadPage = "https://matt.ucc.asn.au/dropbear/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
