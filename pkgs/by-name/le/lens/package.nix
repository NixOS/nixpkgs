{
  stdenv,
  callPackage,
  fetchurl,
  lib,
  writeShellApplication,
  common-updater-scripts,
  curl,
  jq,
}:

let

  pname = "lens-desktop";
  version = "2026.3.251250";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha256-8wSJ46njHtC2qhCRNMmVwI/YNs06qoVQn5qkXICACy4=";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha256-Je5+MjhedffRyKFjoh1hJedHXDUASvXZKVd1saLwacc=";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha256-jJRlz4l5hMnk/bDvRuSVVuoe2SMQuZdAZ3RnGaUuvhU=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  passthru = {
    updateScript = writeShellApplication {
      name = "update-lens";
      runtimeInputs = [
        common-updater-scripts
        curl
        jq
      ];
      text = ''
        linux=$(curl -sSfL https://api.k8slens.dev/binaries/latest-linux.json)
        mac=$(curl -sSfL https://api.k8slens.dev/binaries/latest-mac.json)

        linuxVersion=$(jq -r '.version' <<<"$linux")
        macVersion=$(jq -r '.version' <<<"$mac")
        if [[ "$linuxVersion" != "$macVersion" ]]; then
          echo "error: linux and mac manifest versions differ: $linuxVersion vs $macVersion" >&2
          exit 1
        fi
        version=''${linuxVersion%-latest}

        hashFor() {
          echo "sha512-$(jq -r --arg s "$2" '[.files[] | select(.url | endswith($s))][0].sha512' <<<"$1")"
        }

        update() {
          update-source-version lens "$version" "$2" --system="$1" --ignore-same-version --ignore-same-hash
        }

        update x86_64-linux   "$(hashFor "$linux" .AppImage)"
        update x86_64-darwin  "$(hashFor "$mac"   -latest.dmg)"
        update aarch64-darwin "$(hashFor "$mac"   -arm64.dmg)"
      '';
    };
  };

  meta = {
    description = "Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = lib.licenses.lens;
    maintainers = with lib.maintainers; [
      dbirks
      RossComputerGuy
      starkca90
    ];
    platforms = builtins.attrNames sources;
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      passthru
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      passthru
      meta
      ;
  }
