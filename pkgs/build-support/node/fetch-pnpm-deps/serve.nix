{
  writeShellApplication,
  pnpm,
  pnpmDeps,
  zstd,
}:

writeShellApplication {
  name = "serve-pnpm-store";

  runtimeInputs = [
    pnpm
    zstd
  ];

  text = ''
    storePath=$(mktemp -d)

    fetcherVersion=$(cat "${pnpmDeps}/.fetcher-version" || echo 1)

    clean() {
      echo "Cleaning up temporary store at '$storePath'..."

      rm -rf "$storePath"
    }

    echo "Copying pnpm store '${pnpmDeps}' to temporary store..."

    if [[ $fetcherVersion -ge 3 ]]; then
      tar --zstd -xf "${pnpmDeps}/pnpm-store.tar.zst" -C "$storePath"
    else
      cp -Tr "${pnpmDeps}" "$storePath"
    fi

    chmod -R +w "$storePath"

    echo "Run 'pnpm install --store-dir \"$storePath\"' to install packages from this store."

    trap clean EXIT

    pnpm server start \
      --store-dir "$storePath"
  '';
}
