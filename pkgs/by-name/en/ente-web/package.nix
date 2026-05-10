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
  sd,
  wasm-bindgen-cli_0_2_108,
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
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web-${enteApp}";
  version = "1.3.36";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [
      "rust"
      "web"
    ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-o75r8LFgG3BT3IIPiD9x6gY3fRDoxJ3ZTBPAYr3hLWI=";
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
    hash = "sha256-NYPxaVYEaJVcsRX6wLVJd+/UUJrNel0zTPYGdEv8a+U=";
  };
  cargoRoot = "packages/wasm";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-eGu+s8g0nGijYfjo8RkT5/iBfbwk5cBMacbe/gO03NI=";
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
    wasm-bindgen-cli_0_2_108
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
    # Replace hardcoded links pointing to the public ente instance so that
    # users of a self-hosted instance are not accidentally redirected there
    + lib.optionalString (enteMainUrl != null) ''
      for pattern in "https://web.ente.io" "https://ente.com" "https://ente.io"; do
        mapfile -d "" -t files < <(grep -rlFZ -- "$pattern" apps/)
        ${lib.getExe sd} -F -- "$pattern" ${lib.escapeShellArg enteMainUrl} "''${files[@]}"
      done
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

  passthru = {
    tests = { inherit (nixosTests) ente; };
    updateScript = writeScript "update-ente-web" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p coreutils nix-update gnugrep gnused curl

      set -eu -o pipefail

      # Assume the current working directory is Nixpkgs
      file_path="./pkgs/by-name/en/ente-web/package.nix"

      # Extract version, then update
      old_version=$(grep -oP 'version = "\K[^"]+' "$file_path" | head -n1)
      if [[ -z "$old_version" ]]; then
        echo "Failed to extract old version from $file_path"
        exit 1
      fi

      nix-update ente-web --version-regex 'photos-v(.*)'

      new_version=$(grep -oP 'version = "\K[^"]+' "$file_path" | head -n1)
      if [[ -z "$new_version" ]]; then
        echo "Failed to extract new version from $file_path"
        exit 1
      fi

      if [[ "$old_version" == "$new_version" ]]; then
        echo "No update"
        exit 0
      fi

      echo "Updated to version $new_version, checking wasm-bindgen..."

      # Fetch Cargo.lock from GitHub instead of cloning repository
      cargo_lock_url="https://raw.githubusercontent.com/ente-io/ente/photos-v$new_version/web/packages/wasm/Cargo.lock"

      wasm_bindgen_version=$(curl -s "$cargo_lock_url" | tr -d '\r' | grep -A1 '^name = "wasm-bindgen"$' | grep -oP 'version = "\K[^"]+' | head -n1)

      if [[ -z "$wasm_bindgen_version" ]]; then
        echo "Failed to find wasm-bindgen version in Cargo.lock from $cargo_lock_url"
        exit 1
      fi

      echo "Found wasm-bindgen version: $wasm_bindgen_version"

      # Construct new attribute name
      wasm_bindgen_attr="wasm-bindgen-cli_''${wasm_bindgen_version//./_}"

      # Replace old attribute name in file
      sed -i "s/wasm-bindgen-cli_[0-9_]\+/$wasm_bindgen_attr/g" "$file_path"

      echo "Successfully updated wasm-bindgen-cli to $wasm_bindgen_attr"
    '';
  };

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
