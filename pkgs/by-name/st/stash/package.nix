{
  lib,
  stdenv,
  fetchurl,
}:
let
  inherit (lib.importJSON ./version.json) url version sources;
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = "stash";

  src = fetchurl {
    inherit (sources.${stdenv.system}) hash;
    url = "${url}/releases/download/${version}/${sources.${stdenv.system}.name}";
  };

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
