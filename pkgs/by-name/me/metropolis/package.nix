{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metropolis";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "5c0";
    repo = "metropolis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z8+FVSkEDMQhRKqpP1g2eLvpXzaQC0hcmrX3Ht/P5yI=";
  };

  cargoHash = "sha256-H/yiasZAx5wdr2OlTLEewH+tgdi0QP9NkeUnLu+XuDc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Cyberpunk system monitor";
    longDescription = ''
      "The year is 20XX. Your processes aren't just rows in a table.
      They're the residents.  Your CPU isn't just silicon.  It's the
      infrastructure.  And the city?  The city is breathing."

      Metropolis is a high-performance, narrative-driven system
      monitor built for the terminal.  It transcends traditional
      hardware monitoring by transforming raw kernel metrics into a
      living, breathing Cyberpunk Skyline.

      Every flicker of a neon sign, every shuttle streaking across the
      sky, and every drop of rain is a direct reflection of your
      system's heartbeat.
    '';
    homepage = "https://github.com/5c0/metropolis";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "metropolis";
  };
})
