{
  lib,
  stdenv,
  fetchurl,
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

stdenv.mkDerivation rec {
  pname = "dropbear";
  version = "2025.88";

  src = fetchurl {
    url = "https://matt.ucc.asn.au/dropbear/releases/dropbear-${version}.tar.bz2";
    sha256 = "sha256-eD9Q6iexfBbaiVePr9tt7PpEu49lkOVpik5NNnLcU9Q=";
  };

  CFLAGS = lib.pipe (lib.attrNames dflags) [
    (builtins.map (name: "-D${name}=\\\"${dflags.${name}}\\\""))
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

  postInstall = lib.optionalString enableSCP ''
    ln -rs $out/bin/scp $out/bin/dbscp
  '';

  patches = [
    # Allow sessions to inherit the PATH from the parent dropbear.
    # Otherwise they only get the usual /bin:/usr/bin kind of PATH
    ./pass-path.patch
  ];

  buildInputs = [
    zlib
    libxcrypt
  ];

  meta = {
    description = "Small footprint implementation of the SSH 2 protocol";
    homepage = "https://matt.ucc.asn.au/dropbear/dropbear.html";
    changelog = "https://github.com/mkj/dropbear/raw/DROPBEAR_${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
