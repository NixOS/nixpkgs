{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "0-unstable-2026-08-20";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  # ix.dev publishes the CLI as self-contained binaries (static-pie on
  # Linux) at content-addressed URLs: the sha256 digest of the binary is
  # the URL path segment, so a release can never mutate an existing URL
  # and every pinned revision stays fetchable. Digests come from
  # https://ix.dev/cli/manifest.json (see update.sh).
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://ix.dev/cli/linux-x86_64/sha256/5754ccfe1eb074c6984dfa503a40372c52fc7d787513898d2062538e79677d43/ix";
      hash = "sha256-V1TM/h6wdMaYTfpQOkA3LFL8fXh1E4mNIGJTjnlnfUM=";
    };

    aarch64-linux = fetchurl {
      url = "https://ix.dev/cli/linux-arm64/sha256/125a8bf7e21fef5d72c55f1e7859e5e75ea4fdeef5092c03da09bb87a2205d9c/ix";
      hash = "sha256-ElqL9+If711yxV8eeFnl516k/e71CSwD2gm7h6IgXZw=";
    };

    aarch64-darwin = fetchurl {
      url = "https://ix.dev/cli/darwin-arm64/sha256/fb1685a1a0dd5fb189cf5670a7d87e5e6dda30fe293da22cae82b58dd500d87c/ix";
      hash = "sha256-+xaFoaDdX7GJz1Zwp9h+Xm3aMP4pPaIsroK1jdUA2Hw=";
    };
  };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ix";
  inherit version;

  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSystem;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/ix

    runHook postInstall
  '';

  # Upstream versions builds by date, so versionCheckHook cannot match the
  # full version string; check the build date instead.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/ix --version | grep -F "${lib.removePrefix "0-unstable-" finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Boot and manage ix.dev virtual machines";
    homepage = "https://ix.dev";
    downloadPage = "https://ix.dev/cli/manifest.json";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.andrewgazelka ];
    mainProgram = "ix";
    platforms = builtins.attrNames srcs;
  };
})
