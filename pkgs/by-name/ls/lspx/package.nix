{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  deno,
  jq,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lspx";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "thefrontside";
    repo = "lspx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NEwcNE5RxN/rl75bRxUQgANtqp26Y88HV/WKMtytt8k=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir --parent $out/lib
    cp --recursive * $out/lib
    cp --recursive ${finalAttrs.passthru.denoDeps}/{vendor,node_modules} $out/lib

    runHook postInstall
  '';

  # Deno would fetch npm metadata to upgrade the lockfile, so run from the
  # vendored dependencies without it.
  postInstall = ''
    makeWrapper ${lib.getExe' deno "deno"} $out/bin/lspx \
      --add-flags "run --allow-all --cached-only --no-lock --vendor --node-modules-dir=manual $out/lib/main.ts" \
      --set DENO_NO_UPDATE_CHECK "1"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/lspx --help
    runHook postInstallCheck
  '';

  passthru = {
    denoDeps = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-deno-deps";
      inherit (finalAttrs) version src;

      strictDeps = true;
      __structuredAttrs = true;

      nativeBuildInputs = [
        deno
        jq
      ];

      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild

        export DENO_DIR=$(mktemp -d) DENO_NO_UPDATE_CHECK=1
        deno install --frozen --vendor --node-modules-dir=auto --entrypoint main.ts

        # The package metadata from jsr lists every published version.  Keep
        # only the vendored versions so that the output stays reproducible.
        for dir in vendor/jsr.io/*/*; do
          versions=()
          for meta in "$dir"/*_meta.json; do
            meta=''${meta##*/}
            versions+=("''${meta%_meta.json}")
          done
          jq '{ scope, name, versions: ($ARGS.positional | map({ (.): { } }) | add) }' \
            "$dir/meta.json" --args "''${versions[@]}" > "$dir/meta.json.new"
          mv "$dir/meta.json.new" "$dir/meta.json"
        done

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir $out
        cp --recursive vendor node_modules $out
        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-ifuRFIbXQW21qoBLtGIwGJWIkWwgyM9jInZpalVs1cg=";
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "denoDeps"
      ];
    };
  };

  meta = {
    description = "Language server multiplexer, supervisor, and interactive shell";
    homepage = "https://github.com/thefrontside/lspx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lspx";
    inherit (deno.meta) platforms;
  };
})
