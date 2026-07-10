{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  steam-run,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "noita_entangled_worlds";
  version = "0.32.5";

  src = fetchzip {
    url = "https://github.com/IntQuant/noita_entangled_worlds/releases/download/v${finalAttrs.version}/noita-proxy-linux.zip";
    hash = "sha256-qvcSf82RqPoRVwVVWqMcQNEa03b/asLgBwD5hsbyBoE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    steam-run
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/libexec
    cp noita_proxy.x86_64 $out/libexec/noita-proxy-bin
    cp libsteam_api.so $out/libexec/

    # Create a wrapper script that calls the binary from libexec
    makeWrapper ${steam-run}/bin/steam-run $out/bin/noita-proxy \
      --add-flags "$out/libexec/noita-proxy-bin"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/IntQuant/noita_entangled_worlds/releases/tag/v${finalAttrs.version}";
    description = "True coop multiplayer mod for Noita";
    homepage = "https://github.com/IntQuant/noita_entangled_worlds";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ orbsa ];
    platforms = lib.platforms.linux;
    mainProgram = "noita-proxy";
  };
})
