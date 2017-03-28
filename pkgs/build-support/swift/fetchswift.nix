{ stdenv, cacert, git, swift, jq }:
{ name, src, sha256 }:

stdenv.mkDerivation {
  name = "${name}-fetch";

  buildInputs = [ swift git cacert jq ];
  inherit src;

  buildPhase = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    swift package -v fetch

    while IFS= read -r -d ''$'\0' i; do
      repo=''${i##*/}
      name=''${repo%%-[0-9-]*}

      # Lookup URL (maybe just check git remote info?)
      url=$(jq <.build/repositories/checkouts-state.json '.repositories|.[]|select(.handle.subpath==$path)|.handle.repositoryURL' --arg path "$repo" -jcM)
      echo "URL=$url"
      # And use this to get name of the package
      pkg=$(jq <Package.pins '.pins|.[]|select(.repositoryURL==$url)|.package' --arg url "$url" -jcM)

      # Pretend we want to use local version of this dep
      echo "Found dep: $repo -> $name \"$pkg\""
      swift package edit $pkg --branch imaginary-branch

      # rename repo -> name to workaround the use of unstable hash
      # (Is this done concurrently with 'find'? Seems bad...)
      mv .build/repositories/$repo .build/repositories/$name
      mv .build/checkouts/$repo .build/checkouts/$name

      sed -i "s,$repo,$name,g" .build/workspace-state.json .build/repositories/checkouts-state.json

      # Nuke all git information
      rm Packages/$pkg/.git -rf
      rm .build/repositories/$name -rf
      mkdir .build/repositories/$name
      rm .build/checkouts/$name/.git -rf
    done < <(find .build/repositories -type d -maxdepth 1 -mindepth 1 -print0)

    # Massage json files into deterministic goodness
    cp .build/workspace-state.json workspace-state.json
    jq <workspace-state.json '.dependencies|=sort_by(.repositoryURL)' -cMS > .build/workspace-state.json
    rm workspace-state.json

    # TODO: This might not exist
    cp .build/repositories/checkouts-state.json checkouts-state.json
    jq <checkouts-state.json '.repositories|=sort_by(.key)' -cMS > .build/repositories/checkouts-state.json
    rm checkouts-state.json
  '';

  installPhase = ''
    mkdir -p $out
    cp -ar .build ./* $out/

    # XXX: provide some debugging output to see find out why we are seeing
    # sporadic hash mismatches
    find $out ! -type f
    find $out -type f -exec sha256sum {} +
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
