{
  lib,
  stdenv,
  fetchurl,
}:
let

  version = "0.25.1";

  sources = {
    x86_64-linux = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-linux";
      hash = "sha256-Rb4x6iKx6T9NPuWWDbNaz+35XPzLqZzSm0psv+k2Gw4=";
    };
    aarch64-linux = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-linux-arm64v8";
      hash = "sha256-6qPyIYKFkhmBNO47w9E91FSKlByepBOnl0MNJighGSc=";
    };
    x86_64-darwin = {
      url = "https://github.com/stashapp/stash/releases/download/v${version}/stash-macos";
      hash = "sha256-W8+rgqWUDTOB8ykGO2GL9tKEjaDXdx9LpFg0TAtJsxM=";
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
