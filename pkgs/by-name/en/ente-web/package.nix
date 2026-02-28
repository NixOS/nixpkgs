{
  lib,
  stdenv,
  binaryen,
  cargo,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  rustPlatform,
  rustc,
  wasm-bindgen-cli_0_2_106,
  wasm-pack,
  yarnConfigHook,
  yarnBuildHook,
  writeScript,
  extraBuildEnv ? { },
  # This package contains serveral sub-applications. This specifies which of them you want to build.
  enteApp ? "photos",
  # Accessing some apps (such as account) directly will result in a hardcoded redirect to ente.io.
  # To prevent users from accidentally logging in to ente.io instead of the selfhosted instance, you
  # can set this parameter to override these occurrences with your own url. Must include the schema.
  # Example: https://my-ente.example.com
  enteMainUrl ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web-${enteApp}";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [
      "rust"
      "web"
    ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Bfu4O+kBtXxxVyx2iC/577TPD049ifjg1ItmKN4bx4U=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-dedLmQP15V+gAtycXx1fpWfjXWsTPLXPPcCIAcr/ME0=";
  };
  cargoRoot = "packages/wasm";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-OPmO+4VlM4Fy9vjgb2ZxDP6Ber9A+ANwix1dZSuEgUE=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    binaryen
    cargo
    rustPlatform.cargoSetupHook
    rustc
    rustc.llvmPackages.lld
    nodejs
    wasm-bindgen-cli_0_2_106
    wasm-pack
  ];

  # See: https://github.com/ente-io/ente/blob/main/web/apps/photos/.env
  env = extraBuildEnv;

  postPatch =
    # Use our `wasm-pack` binary, rather than the Node version, which is
    # just a wrapper that tries to download the actual binary
    ''
      substituteInPlace \
        packages/wasm/package.json \
        --replace-fail "wasm-pack " ${lib.escapeShellArg "${wasm-pack}/bin/wasm-pack "}
    ''
    # Replace hardcoded ente.io urls if desired
    + lib.optionalString (enteMainUrl != null) ''
      substituteInPlace \
        apps/payments/src/services/billing.ts \
        apps/photos/src/pages/shared-albums.tsx \
        --replace-fail "https://ente.io" ${lib.escapeShellArg enteMainUrl}

      substituteInPlace \
        apps/accounts/src/pages/index.tsx \
        --replace-fail "https://web.ente.io" ${lib.escapeShellArg enteMainUrl}
    '';

  yarnBuildScript = "build:${enteApp}";
  installPhase =
    let
      distName = if enteApp == "payments" then "dist" else "out";
    in
    ''
      runHook preInstall

      cp -r apps/${enteApp}/${distName} $out

      runHook postInstall
    '';

  passthru.updateScript = writeScript "update-ente-web" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix coreutils nix-update gnugrep gnused curl

    set -eu -o pipefail

    # 1. Find nixpkgs root
    nixpkgs_dir="$PWD"
    while [[ ! -f "$nixpkgs_dir/maintainers/scripts/update.nix" ]]; do
      nixpkgs_dir="$(dirname "$nixpkgs_dir")"
      if [[ "$nixpkgs_dir" == "/" ]]; then
        echo "Error: Could not find nixpkgs root. Are you running this inside nixpkgs?"
        exit 1
      fi
    done

    cd "$nixpkgs_dir"

    # 2. Get absolute path of this file
    pos=$(nix-instantiate --eval --strict --expr '(import ./. {}).ente-web.meta.position' | tr -d '"')
    file_path="''${pos%:*}" # Strips the trailing line number (e.g., :123)

    if [[ ! -f "$file_path" ]]; then
      echo "Could not find package file at $file_path"
      exit 1
    fi

    # 3. Hash file to detect if nix-update makes changes
    old_hash=$(sha256sum "$file_path")

    nix-update ente-web --version-regex 'photos-v(.*)'

    new_hash=$(sha256sum "$file_path")
    if [[ "$old_hash" == "$new_hash" ]]; then
      echo "No update"
      exit 0
    fi

    # 4. Extract updated version from file
    new_version=$(grep -oP 'version = "\K[^"]+' "$file_path" | head -n1)

    if [[ -z "$new_version" ]]; then
      echo "Failed to extract new version from $file_path"
      exit 1
    fi

    echo "Updated to version $new_version, checking wasm-bindgen..."

    # 5. Fetch Cargo.lock from GitHub instead of cloning repository
    cargo_lock_url="https://raw.githubusercontent.com/ente-io/ente/photos-v$new_version/web/packages/wasm/Cargo.lock"

    wasm_bindgen_version=$(curl -s "$cargo_lock_url" | tr -d '\r' | grep -A1 '^name = "wasm-bindgen"$' | grep -oP 'version = "\K[^"]+' | head -n1)

    if [[ -z "$wasm_bindgen_version" ]]; then
      echo "Failed to find wasm-bindgen version in Cargo.lock from $cargo_lock_url"
      exit 1
    fi

    echo "Found wasm-bindgen version: $wasm_bindgen_version"

    # Construct new attribute name
    wasm_bindgen_attr="wasm-bindgen-cli_''${wasm_bindgen_version//./_}"

    # 6. Replace old attribute name in file
    sed -i "s/wasm-bindgen-cli_[0-9_]\+/$wasm_bindgen_attr/g" "$file_path"

    echo "Successfully updated wasm-bindgen-cli to $wasm_bindgen_attr"
  '';

  meta = {
    description = "Ente application web frontends";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/ente/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      oddlama
      nicegamer7
    ];
    platforms = lib.platforms.all;
  };
})
