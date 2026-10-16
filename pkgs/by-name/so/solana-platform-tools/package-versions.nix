{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  zlib,
  libffi,
  ncurses,
  xz,
}:

let
  # https://github.com/anza-xyz/platform-tools/releases
  hashes = {
    "1.54" = {
      linux-x86_64 = "sha256-/MQWMcf3dWG/VBIhi/KXUB3M8DBeooDzOPCs4qq58x4=";
      linux-aarch64 = "sha256-9igS3Za2scjg4s9ncUaRLFjIPpXXYsMOiSMNZp+cLmo=";
      osx-x86_64 = "sha256-0ctxZYkgB9Ea1y/e0Wx2km5d+p/yhv49mZRAwa80p1g=";
      osx-aarch64 = "sha256-HIs69ehhThxFk5OpXFsZv7zI7ROCKhy1OfrmhHH5v7s=";
    };
    "1.57" = {
      linux-x86_64 = "sha256-sPevEErfcm//KmoJ6i6y8tKWXJIpX01ziMCNFA4MKwA=";
      linux-aarch64 = "sha256-8vMckyXLLQAkTfI7ShoJBOUYGc7EnTkjWj7T7iMgN10=";
      osx-x86_64 = "sha256-5vYjGxSeZK1swSYF0PmTQFzlWGKqREBsAjVjFZ+MPK8=";
      osx-aarch64 = "sha256-SMMsLsOsNym1yvH91sQUVJYSXt8EOyZisFhr+8kys0o=";
    };
  };

  mkPlatformTools =
    version:
    stdenv.mkDerivation (finalAttrs: {
      pname = "solana-platform-tools";
      inherit version;
      __structuredAttrs = true;
      strictDeps = true;

      src =
        let
          arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
          platform = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
        in
        fetchurl {
          url = "https://github.com/anza-xyz/platform-tools/releases/download/v${finalAttrs.version}/platform-tools-${platform}-${arch}.tar.bz2";
          hash = hashes.${version}."${platform}-${arch}";
        };

      # The archive extracts several top-level directories (llvm/, rust/, env-vars/).
      sourceRoot = ".";

      nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
      buildInputs = [
        stdenv.cc.cc.lib
        zlib
        libffi
        ncurses
        xz
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        for dir in llvm rust env-vars; do
          [ -d "$dir" ] && cp -r "$dir" $out/
        done
        [ -f version.md ] && cp version.md $out/
        runHook postInstall
      '';

      # python310 is not present in nixpkgs and lldb depend on it.
      # do not ship debug related things until this is resolved
      # https://github.com/anza-xyz/platform-tools/pull/109
      preFixup = ''
        find $out/llvm/lib -maxdepth 1 -name 'liblldb*' -delete
        find $out/llvm/bin -maxdepth 1 \
          \( -name 'lldb*' -o -name 'solana-lldb' -o -name 'solana_commands' \
             -o -name 'rust_types.py' -o -name 'solana_*.py' \) -delete
        rm -rf $out/llvm/lib/python3.*
      '';

      meta = {
        description = "Solana SBF platform tools (LLVM + Rust toolchain)";
        homepage = "https://github.com/anza-xyz/platform-tools";
        changelog = "https://github.com/anza-xyz/platform-tools/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ _0xgsvs ];
        platforms = lib.platforms.unix;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    });
in
{
  solana-platform-tools_154 = mkPlatformTools "1.54";
  solana-platform-tools_157 = mkPlatformTools "1.57";

  solana-platform-tools_latest = mkPlatformTools "1.57";
}
