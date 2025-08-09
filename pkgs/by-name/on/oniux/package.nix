{
  lib,
  rustPlatform,
  fetchFromGitLab,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniux";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo/core";
    repo = "oniux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLtII1pO1G9dsmu7Fq+CwvgYfrWCaSRiCs1+VhlU3Ck=";
  };

  cargoHash = "sha256-tYHGuBEuwrB/gSCWbSKEavlADIYiNpWjOpVQxYgEC+U=";

  nativeBuildInputs = [
    perl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/core/oniux";
    description = "Isolate Applications over Tor using Linux Namespaces";
    maintainers = with lib.maintainers; [ tnias ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oniux";
  };
})
