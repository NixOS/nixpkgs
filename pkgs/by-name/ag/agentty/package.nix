{
  lib,
  stdenvNoCC,
  fetchurl,
}:

# NOTE: `version` and both hashes below are RENDERED per release from the
# single source of truth — `project(agentty VERSION X.Y.Z)` in the upstream
# CMakeLists.txt — by scripts/release.sh. They are not hand-maintained: a
# version bump upstream re-pins this file automatically. Keep that invariant
# when updating (bump version, then update both SRI hashes from the release
# SHA256SUMS).
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "agentty";
  version = "0.2.6";

  # agentty is a C++26 project (std::expected / std::format requested via
  # CMake's cxx_std_26) that needs a very recent GCC not reliably available
  # across nixpkgs' supported stdenvs, so we install the upstream fully-static
  # musl release binary rather than compiling from source.
  src =
    let
      selector = {
        x86_64-linux = {
          suffix = "linux-x86_64";
          hash = "sha256-eJuwPbVoEkRmEFhc4dXchfji/nePIvNzVKKgSV1ex2A=";
        };
        aarch64-linux = {
          suffix = "linux-aarch64";
          hash = "sha256-CidYPIdBYPcIWlFZ75cwlakm4/d0XmceYI+up79lWxQ=";
        };
      };
      choice =
        selector.${stdenvNoCC.hostPlatform.system}
          or (throw "agentty: unsupported platform ${stdenvNoCC.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/1ay1/agentty/releases/download/v${finalAttrs.version}/agentty-${choice.suffix}";
      inherit (choice) hash;
    };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/agentty"
    runHook postInstall
  '';

  meta = {
    description = "Blazing-fast Claude in your terminal — single static binary, sandboxed, airgap-capable";
    homepage = "https://github.com/1ay1/agentty";
    license = lib.licenses.mit;
    mainProgram = "agentty";
    maintainers = [ ]; # add yourself via maintainers/maintainer-list.nix if you take this on
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
