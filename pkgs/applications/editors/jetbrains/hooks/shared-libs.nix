{
  lib,
  makeSetupHook,
  patchelf,
  stdenv,
}:
makeSetupHook
  {
    name = "shared-libs-hook";
    propagatedBuildInputs = [ patchelf ];
    meta = {
      description = "Setup hook that rewrites sonames in libraries bundled with JetBrains IDEs";
      teams = [ lib.teams.jetbrains ];
    };
  }
  (
    builtins.toFile "shared-libs-hook.sh" ''
      jetbrainsPatchSharedLibs() {
        ls -d \
          $out/*/bin/*/linux/*/lib/liblldb.so \
          $out/*/bin/*/linux/*/lib/python3.*/lib-dynload/* \
          $out/*/plugins/*/bin/*/linux/*/lib/liblldb.so \
          $out/*/plugins/*/bin/*/linux/*/lib/python3.*/lib-dynload/* |
        xargs patchelf \
          --replace-needed libssl.so.10 libssl.so \
          --replace-needed libssl.so.1.1 libssl.so \
          --replace-needed libcrypto.so.10 libcrypto.so \
          --replace-needed libcrypto.so.1.1 libcrypto.so \
          --replace-needed libcrypt.so.1 libcrypt.so \
          ${lib.optionalString stdenv.hostPlatform.isAarch "--replace-needed libxml2.so.2 libxml2.so"}
      }
      preFixupHooks+=(jetbrainsPatchSharedLibs)
    ''
  )
