{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keifu";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "trasta298";
    repo = "keifu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8fjR204Wa9LJa9JGQ1CRHDoiHei6P3J81RGgA0G77EA=";
  };

  cargoHash = "sha256-OhNT+IbR1A7QD03/I+ju2h1LArVPL47BnVmit3tNSOA=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI tool for visualizing Git commit graphs";
    homepage = "https://github.com/trasta298/keifu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yutakobayashidev ];
    mainProgram = "keifu";
  };
})
