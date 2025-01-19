{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  coreutils,
  gnugrep,
  gnused,
  jq,
  lldap,
  unixtools,
  curl,
  makeWrapper,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "lldap-cli";
  version = "0-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "Zepmann";
    repo = "lldap-cli";
    rev = "2a80dc47c334c88faf3000b45c631bc2cea09906";
    hash = "sha256-uk7SOiQmUYtoJnihSnPsu/7Er4wXX4xvPboJaNSMjkM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    runHook prePatch

    # fix .lldap-cli-wrapped showing up in usage
    substituteInPlace lldap-cli \
      --replace-fail '$(basename $0)' lldap-cli

    runHook postPatch
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm555 lldap-cli -t $out/bin
    wrapProgram $out/bin/lldap-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          unixtools.column
          coreutils
          gnugrep
          gnused
          jq
          lldap # Needed for lldap_set_password
          curl
        ]
      }
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Command line tool for managing LLDAP";
    longDescription = ''
      LDAP-CLI is a command line interface for LLDAP.

      LLDAP uses GraphQL to offer an HTTP-based API.
      This API is used by an included web-based user interface.
      Unfortunately, LLDAP lacks a command-line interface,
      which is a necessity for any serious administrator.
      LLDAP-CLI translates CLI commands to GraphQL API calls.
    '';
    homepage = "https://github.com/Zepmann/lldap-cli";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nw ];
    mainProgram = "lldap-cli";
    platforms = lib.platforms.unix;
  };
}
