{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bashNonInteractive,
  curl,
  jq,
  coreutils,
  gawk,
  gnugrep,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cloudflare-ddns";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "fernvenue";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-+0AQAa7j6nPaIy0gHEKM1WgPJ7661+NBB1j/dsb7X9Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace cloudflare-ddns.sh \
      --replace-fail '#!/bin/bash' '#!${lib.getExe bashNonInteractive}'
  '';

  installPhase = ''
    runHook preInstall

    install -D cloudflare-ddns.sh $out/bin/cloudflare-ddns

    wrapProgram $out/bin/cloudflare-ddns \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
          coreutils
          gawk
          gnugrep
        ]
      }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight Cloudflare DDNS script";
    longDescription = ''
      A lightweight script for updating Cloudflare DNS records automatically.
      Supports IPv4 and IPv6, multiple records, smart monitoring, automatic caching,
      multiple authentication methods, proxy support, systemd integration,
      Telegram notifications, CSV logging, and hook commands.
    '';
    homepage = "https://github.com/fernvenue/cloudflare-ddns";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bdim404 ];
    platforms = lib.platforms.unix;
    mainProgram = "cloudflare-ddns";
  };
})
