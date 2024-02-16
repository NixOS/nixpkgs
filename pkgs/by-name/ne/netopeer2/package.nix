{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libnetconf2
, sysrepo
, systemdMinimal
, libyang
, openssl
, libssh
, pcre2
, cmocka
}:

stdenv.mkDerivation rec {
  pname = "netopeer2";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Netopeer2";
    rev = "v${version}";
    hash = "sha256-eStuZT+EGfEH5VC0GicIM71N26ZGhj0SK+40fTW1cZw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libnetconf2
    sysrepo
    systemdMinimal
    libyang
    openssl
    libssh
    pcre2
    # For tests
    cmocka
  ];

  cmakeFlags = [
    # This will break cross compilation otherwise
    # and try to manipulate a global state (to install sysrepo modules).
    "-DSYSREPO_SETUP=OFF"
  ];

  meta = with lib; {
    description = "NETCONF toolset";
    longDescription = ''
      Netopeer2 is a server for implementing network configuration management
      based on the NETCONF Protocol. This is the second generation, originally
      available as the Netopeer project.

      It contains also the command-line tool `netopeer2-cli`.
    '';
    homepage = "https://github.com/CESNET/Netopeer2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "netopeer2";
    platforms = platforms.all;
  };
}
