{ lib
, stdenv
, autoreconfHook

  # New helper functions
, nixpkgsUpdater # Optional
, srcFromJSON

  # projectInfo is overloaded, it can be:
  # - Path to an "info.json" file (That's the case in nixpkgs)
  # - Attribute set with values to use in mkDerivation
, projectInfo ? srcFromJSON ./info.json
}:

stdenv.mkDerivation {
  pname = "simple";

  inherit (projectInfo) src version;

  nativeBuildInputs = [ autoreconfHook ];
  preAutoreconf = "cd src";

  # nixpkgsUpdater is optional, we can define our own function to update info.json
  passthru.updateScript = nixpkgsUpdater {
    # See
    # https://nixos.org/manual/nixpkgs/stable/#chap-pkgs-fetchers
    # Supported fetchers: fetchFromGitHub, fetchgit
    fetcher = "fetchFromGitHub";

    # Extra args for the fetcher function
    # All the arguments we want to pass to the underlaying fetch function (fetchgit, fetchFromGitHub, ...),
    # except hash and rev
    fetcherArgs = {
      owner = "jlesquembre";
      repo = "simple-flake";
    };

    # Optionally, we can provide a script to find the latest version. If not provided, the default one is used
    # getLastVersion =
    #   writeShellApplication {
    #     name = "get-last-version";
    #     runtimeInputs = [ curl jq ];
    #     text =
    #       ''
    #         curl -s "https://api.github.com/repos/jlesquembre/simple-flake/tags" | jq -r '.[0].name'
    #       '';
    #   };
  };

  meta = with lib; {
    description = "A simple package";
    homepage = "https://test.com/";
    license = licenses.epl10;
    longDescription = ''
    '';
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.unix;
  };
}
