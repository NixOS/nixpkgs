{
  lib,
  stdenv,
  fetchurl,
  libgcc,
  autoPatchelfHook,
  testers,
  oakctl,
}:

let
  version = "0.13.2";

  # Note: Extracted from install script
  # https://oakctl-releases.luxonis.com/oakctl-installer.sh
  sources = {
    x86_64-linux = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/linux_x86_64/oakctl";
      hash = "sha256-uS7CUnj9+/kBwGaaZA9P6R2//vhZ1cJW+lhkQePZ0is=";
    };
    aarch64-linux = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/linux_aarch64/oakctl";
      hash = "sha256-+WFSV3TALeJtdcxkcduaN8tWGLCrOxvs3UV6cOr1xAI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/darwin_arm64/oakctl";
      hash = "sha256-OgVmfYcRNVcLGjEbxdVUtsV45vICj+jKPQJ578aRwZs=";
    };
    x86_64-darwin = fetchurl {
      url = "https://oakctl-releases.luxonis.com/data/${version}/darwin_x86_64/oakctl";
      hash = "sha256-KjJxwMRLs0XqiOTHjke+dSVKBftwBDYppjrqsbf0Qe8=";
    };
  };

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "oakctl";
  inherit version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  passthru.tests.version = testers.testVersion {
    command = "HOME=$TMPDIR oakctl version";
    package = oakctl;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgcc
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D -m 0755 $src $out/bin/oakctl

    runHook postInstall
  '';

  # Note: The command 'oakctl self-update' won't work as the binary is located in the nix/store
  meta = {
    description = "Tool to interact with Luxonis OAK4 cameras";
    homepage = "https://docs.luxonis.com/software-v3/oak-apps/oakctl/";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "oakctl";
    maintainers = with lib.maintainers; [ phodina ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
