{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "chasquid";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "albertito";
    repo = "chasquid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FNr1DjH5AaLZdPsLy/jowpXkX3YhLkH2ygUANMD9ON0=";
  };

  vendorHash = "sha256-zRd4CCLv9gVLykLazGH2P+XPKO8xh5QKshFrVP4YIZY=";

  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  passthru.updateScript = nix-update-script { };

  # https://github.com/albertito/chasquid/pull/84
  patches = [
    ./detect-dovecot-sock.patch
    ./detect-lego-cert.patch
  ];

  __structuredAttrs = true;

  meta = {
    description = "SMTP (email) server with a focus on simplicity, security, and ease of operation";
    homepage = "https://blitiri.com.ar/p/chasquid/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "chasquid";
    maintainers = with lib.maintainers; [
      ThinkChaos
    ];
  };
})
