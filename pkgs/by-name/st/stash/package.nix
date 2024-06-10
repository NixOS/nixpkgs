{
  lib,
  stdenv,
  fetchurl,
}:
let

  version = "0.26.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-linux";
      hash = "sha256-Z+Zd3WXMABa8MmpX4xGdHavre5nzYkg5Ok+0b8dM1N4=";
    };
    aarch64-linux = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-linux-arm64v8";
      hash = "sha256-5e2r/qZXD0nCuw+jPDb9LWGclFWpxHIrJsoLjbBvogg=";
    };
    x86_64-darwin = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-macos";
      hash = "sha256-jJPsjVLneqmtZduiUjM1nPX7t39cH/UWTXve68EC4Jw=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = "stash";

  src = fetchurl { inherit (sources.${stdenv.system}) url hash; };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/stash

    runHook postInstall
  '';

  meta = with lib; {
    description = "Stash is a self-hosted porn app";
    homepage = "https://github.com/stashapp/stash";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Golo300 ];
    platforms = builtins.attrNames sources;
    mainProgram = "stash";
  };
})
