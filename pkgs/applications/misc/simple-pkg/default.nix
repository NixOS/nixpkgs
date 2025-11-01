# Original in external repo, but copied to nixpkgs by nixpkgsUpdater
{ lib
, stdenv
, autoreconfHook

  # New helper functions
, nixpkgsUpdater
, srcFromJSON

  # projectSrc is overloaded, it can be:
  # - Path to an "info.json" file (That's the case in nixpkgs)
  # - The src attribute passed to mkDerivation (That's the case in upstream)
, projectSrc ? ./info.json
}:

let
  srcData = srcFromJSON projectSrc;
in

stdenv.mkDerivation {
  pname = "simple";

  inherit (srcData) src version;

  nativeBuildInputs = [ autoreconfHook ];
  preAutoreconf = "cd src";

  passthru.updateScript = nixpkgsUpdater {
    # See
    # https://nixos.org/manual/nixpkgs/stable/#chap-pkgs-fetchers
    # Supported fetchers: fetchFromGitHub
    fetcher = "fetchFromGitHub";

    # Extra args for the fetcher function
    # All the arguments we want to pass to the underlaying fetch function (fetchgit, fetchFromGitHub, ...),
    # except hash and rev
    fetcherArgs = {
      owner = "jlesquembre";
      repo = "simple-flake";
    };

    # List of files to sync with nixpkgs, relative to the Git repository root.
    # The most common case is to sync itself
    syncFiles = [ "pkgs/default.nix" ];

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
