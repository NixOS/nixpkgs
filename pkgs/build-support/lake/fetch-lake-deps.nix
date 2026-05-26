# fetchLakeDeps: fixed-output derivation that fetches Lake dependencies.
#
# Reads lake-manifest.json from the source tree, clones each git
# dependency at its pinned revision, and produces a directory of
# package sources.  The output is hash-verified via `lakeHash`.
#
# This follows the same pattern as buildGoModule's `goModules` FOD.
{
  lib,
  stdenvNoCC,
  gitMinimal,
  cacert,
  jq,
}:

{
  name,
  src,
  hash,
  sourceRoot ? "",
  patches ? [ ],
  prePatch ? "",
  postPatch ? "",
  # Package names to skip (e.g. already packaged in nix).
  excludePackages ? [ ],
}:

stdenvNoCC.mkDerivation {
  name = "${name}-lake-deps";

  inherit
    src
    sourceRoot
    patches
    prePatch
    postPatch
    ;

  nativeBuildInputs = [
    gitMinimal
    cacert
    jq
  ];

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND"
    "SOCKS_SERVER"
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    if [ ! -f lake-manifest.json ]; then
      echo "fetchLakeDeps: lake-manifest.json not found" >&2
      exit 1
    fi

    export HOME="$TMPDIR"
    export GIT_SSL_CAINFO="$NIX_SSL_CERT_FILE"

    mkdir -p "$TMPDIR/packages"

    jq -c --argjson exclude ${lib.escapeShellArg (builtins.toJSON excludePackages)} \
      '.packages[] | select(.type == "git") | select(.name as $n | $exclude | index($n) | not)' \
      lake-manifest.json | while IFS= read -r pkg; do
      name=$(echo "$pkg" | jq -r '.name')
      url=$(echo "$pkg" | jq -r '.url')
      rev=$(echo "$pkg" | jq -r '.rev')

      echo "fetchLakeDeps: cloning $name ($url @ $rev)"

      git clone --filter=blob:none --no-checkout "$url" "$TMPDIR/packages/$name"
      git -C "$TMPDIR/packages/$name" checkout "$rev" --quiet

      # Remove .git to make output deterministic
      rm -rf "$TMPDIR/packages/$name/.git"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv "$TMPDIR/packages" "$out"
    runHook postInstall
  '';

  dontFixup = true;

  outputHashMode = "recursive";
  outputHash = hash;
  outputHashAlgo = if hash == "" then "sha256" else null;
}
