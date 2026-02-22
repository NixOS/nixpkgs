{
  lib,
  stdenvNoCC,
  python3,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    "derivationArgs"
    "sha1"
    "sha256"
    "sha512"
  ];
  extendDrvArgs =
    finalAttrs:
    lib.fetchers.withNormalizedHash { } (
      {

        endpoint ? "https://api.itch.io",

        # The name of the environment variable that contains the itch.io API key.
        # The environment variable needs to be set for the nix building process,
        # which is nix-daemon for multi-user mode.
        apiKeyVar ? "NIX_ITCHIO_API_KEY",

        # The game store page URL in the format of https://{author}.itch.io/{game}
        gameUrl,

        # The upload ID of the downloadable file.
        # To get the upload ID, look at the request URL when you download it.
        upload,

        # Derivation name.
        name ? null,

        # The extra message printed when the API key is not provided
        # or when the account of the API key did not purchase the game.
        extraMessage ? null,

        # Show the download URL without actually downloading it, for testing purposes.
        # Notice that this can potentially leak the API key.
        showUrl ? false,

        outputHash ? lib.fakeHash,
        outputHashAlgo ? null,
        preFetch ? "",
        postFetch ? "",
        nativeBuildInputs ? [ ],
        impureEnvVars ? [ ],
        passthru ? { },
        meta ? { },
        preferLocalBuild ? true,
        derivationArgs ? { },
      }:
      let
        finalHashHasColon = lib.hasInfix ":" finalAttrs.hash;
        finalHashColonMatch = lib.match "([^:]+)[:](.*)" finalAttrs.hash;
      in
      derivationArgs
      // {
        __structuredAttrs = true;

        name = if name != null then name else baseNameOf gameUrl;

        hash =
          if outputHashAlgo == null || outputHash == "" || lib.hasPrefix outputHashAlgo outputHash then
            outputHash
          else
            "${outputHashAlgo}:${outputHash}";
        outputHash =
          if finalAttrs.hash == "" then
            lib.fakeHash
          else if finalHashHasColon then
            lib.elemAt finalHashColonMatch 1
          else
            finalAttrs.hash;
        outputHashAlgo = if finalHashHasColon then lib.head finalHashColonMatch else null;
        outputHashMode = "flat";

        nativeBuildInputs = [ python3 ] ++ nativeBuildInputs;

        inherit preferLocalBuild;

        # ENV
        nixpkgsVersion = lib.trivial.release;
        uploadName = name;
        inherit
          endpoint
          apiKeyVar
          gameUrl
          extraMessage
          showUrl
          preFetch
          postFetch
          ;
        impureEnvVars =
          lib.fetchers.proxyImpureEnvVars
          ++ [
            apiKeyVar
            "NIX_CONNECT_TIMEOUT"
          ]
          ++ impureEnvVars;

        builder = builtins.toFile "builder.sh" ''
          source "$NIX_ATTRS_SH_FILE"
          runHook preFetch
          python ${./fetchitchio.py}
          runHook postFetch
        '';
      }
    );

  inheritFunctionArgs = false;
}
