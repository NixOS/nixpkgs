{
  autoPatchelfHook,
  fetchzip,
  lib,
  nixosTests,
  stdenv,
  stdenvNoCC,
}:
let
  platformMap = {
    "x86_64-linux" = {
      os = "linux";
      arch = "x86_64";
      hash = "sha256-IGks7vmJd/xuJzqhogR5aLVM6eUUe6bACe5VuAWJOWA=";
    };
    "aarch64-linux" = {
      os = "linux";
      arch = "aarch64";
      hash = "sha256-brqotISLIwD1t/2E2oyI7HSkfPpVgUODaNZJcc9o6zI=";
    };
    "x86_64-darwin" = {
      os = "darwin";
      arch = "x86_64";
      hash = "sha256-n8GN2ZmeYEpZ0DB7zwEkXnSUZkAySNAGVn5BLw46fZI=";
    };
    "aarch64-darwin" = {
      os = "darwin";
      arch = "aarch64";
      hash = "sha256-BISrkxLuxlo7KQiW9cUipJpEhOm94gL3GvyivO6LaBU=";
    };
  };
  platform = platformMap.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "2.3.0";

  src = fetchzip {
    url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-${platform.os}-${platform.arch}.zip";
    hash = platform.hash;
    stripRoot = false;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/silverbullet $out/bin/
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) silverbullet;
  };

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet";
    platforms = builtins.attrNames platformMap;
  };
})
