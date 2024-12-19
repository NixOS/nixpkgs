{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitHub,
  pam,
  openssl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "pam_ssh_agent_auth";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "jbeverly";
    repo = "pam_ssh_agent_auth";
    rev = "pam_ssh_agent_auth-${version}";
    sha256 = "YD1R8Cox0UoNiuWleKGzWSzxJ5lhDRCB2mZPp9OM6Cs=";
  };

  ed25519-donna = fetchFromGitHub {
    owner = "floodyberry";
    repo = "ed25519-donna";
    rev = "8757bd4cd209cb032853ece0ce413f122eef212c";
    sha256 = "ETFpIaWQnlYG8ZuDG2dNjUJddlvibB4ukHquTFn3NZM=";
  };

  buildInputs = [
    pam
    openssl
    perl
  ];

  patches = [
    # Allow multiple colon-separated authorized keys files to be
    # specified in the file= option.
    ./multiple-key-files.patch
    ./edcsa-crash-fix.patch
  ];

  configureFlags = [
    # It's not clear to me why this is necessary, but without it, you see:
    #
    # checking OpenSSL header version... 1010108f (OpenSSL 1.1.1h  22 Sep 2020)
    # checking OpenSSL library version... 1010108f (OpenSSL 1.1.1h  22 Sep 2020)
    # checking whether OpenSSL's headers match the library... no
    # configure: WARNING: Your OpenSSL headers do not match your
    # library. Check config.log for details.
    #
    # ...despite the fact that clearly the values match
    "--without-openssl-header-check"
    # Make sure it can find ed25519-donna
    "--with-cflags=-I$PWD"
  ];

  prePatch = "cp -r ${ed25519-donna}/. ed25519-donna/.";

  enableParallelBuilding = true;

  passthru.tests.sudo = nixosTests.ssh-agent-auth;

  meta = {
    homepage = "https://github.com/jbeverly/pam_ssh_agent_auth";
    description = "PAM module for authentication through the SSH agent";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
