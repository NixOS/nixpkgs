{
  stdenvNoCC,
  bash,
  bluesky-pds,
  makeBinaryWrapper,
  jq,
  curl,
  openssl,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdsadmin";
  inherit (bluesky-pds) version src;

  patches = [ ./pdsadmin-offline.patch ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ bash ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    substituteInPlace pdsadmin.sh \
      --replace-fail NIXPKGS_PDSADMIN_ROOT $out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 pdsadmin.sh $out/lib/pds/pdsadmin.sh
    install -Dm755 pdsadmin/*.sh $out/lib/pds
    makeWrapper "$out/lib/pds/pdsadmin.sh" "$out/bin/pdsadmin" \
      --prefix PATH : "${
        lib.makeBinPath [
          jq
          curl
          openssl
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Admin scripts for Bluesky Personal Data Server (PDS)";
    inherit (bluesky-pds.meta) homepage license;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.unix;
    mainProgram = "pdsadmin";
  };
})
