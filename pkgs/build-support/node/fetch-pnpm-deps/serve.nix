{
  writeShellApplication,
  pnpm,
  pnpmDeps,
  zstd,
  lib,
}:

writeShellApplication {
  name = "serve-pnpm-store";

  runtimeInputs = [
    pnpm
    zstd
  ];

  text = ''
    storePath=$(mktemp -d)

    clean() {
      echo "Cleaning up temporary store at '$storePath'..."

      rm -rf "$storePath"
    }

    echo "Copying pnpm store '${pnpmDeps}' to temporary store..."

    tar --zstd -xf "${pnpmDeps}/pnpm-store.tar.zst" -C "$storePath"

    chmod -R +w "$storePath"

    echo "Run 'pnpm install --store-dir \"$storePath\"' to install packages from this store."

    trap clean EXIT

    pnpm server start \
      --store-dir "$storePath"
  '';

  meta = {
    broken = lib.versionAtLeast pnpm.version "11";
  };
}
