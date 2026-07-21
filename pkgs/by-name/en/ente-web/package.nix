{
  lib,
  buildNpmPackage,
  binaryen,
  cargo,
  fetchFromGitHub,
  nodejs,
  rustPlatform,
  rustc,
  sd,
  wasm-bindgen-cli_0_2_125,
  wasm-pack,
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

buildNpmPackage (finalAttrs: {
  pname = "ente-web-${enteApp}";
  version = "1.3.58";

  src = fetchFromGitHub {
    owner = "ente";
    repo = "ente";
    sparseCheckout = [
      "rust"
      "web"
    ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-44iid/vsx3rKt/NGCgdZweJHW24ysQ7qSRq8Hayng9c=";
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
    hash = "sha256-dyDNhDNbcssV4mTzGZkysTftgFfKXNLX2S0jmkX5JR4=";
  };
  cargoRoot = "../rust";

  npmDepsHash = "sha256-JZnF6MfEkm4HCslEgpAuCrSYQYnt8tNPUTFRb1CIVe4=";

  nativeBuildInputs = [
    binaryen
    cargo
    rustPlatform.cargoSetupHook
    rustc
    rustc.llvmPackages.lld
    nodejs
    wasm-bindgen-cli_0_2_125
    wasm-pack
  ];

  # See: https://github.com/ente/ente/blob/main/web/apps/photos/.env
  env = extraBuildEnv;

  postPatch =
    # The Rust workspace lives in `../rust`, outside the `web` sourceRoot, so it
    # is not made writable during unpacking. `wasm-pack` needs to create a cargo
    # target directory there, so make it writable.
    ''
      chmod -R u+w ../rust
    ''
    # Use our `wasm-pack` binary, rather than the Node version, which is
    # just a wrapper that tries to download the actual binary
    + ''
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

  npmBuildScript = "build:${enteApp}";
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
      cargo_lock_url="https://raw.githubusercontent.com/ente-io/ente/photos-v$new_version/rust/Cargo.lock"

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
    changelog = "https://github.com/ente/ente/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      oddlama
      nicegamer7
    ];
    platforms = lib.platforms.all;
  };
})
