{
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pumpkin";
  version = "0-unstable-2026-03-05";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Pumpkin-MC";
    repo = "Pumpkin";
    rev = "fbe13bbacd1a6573aef9e23ad9b92e1c03a603c8";
    hash = "sha256-OYufs3WDL2yHk0tn+G249tfd8PmEr5exKPCRNflRS6Q=";
  };

  cargoHash = "sha256-gjMUqkb7yq0Sn8uokP5UV1vqdyaoI3Sv2Nb7yGNKgZ0=";

  passthru = {
    updateScript = nix-update-script { };
  };

  cargoBuildFlags = [
    "-p"
    "pumpkin"
  ];

  meta = {
    description = "Modern OSS Minecraft server in Rust";
    longDescription = ''
      Pumpkin is a server built from the ground-up. Its plugin system uses WebAssembly
      as a sandboxed plugin runtime. Unlike traditional JVM-based servers such as Vanilla, Spigot, or Paper,
      Pumpkin compiles to a single native executable with no Java runtime
      dependency, achieving startup times around 5 milliseconds, idle memory
      usage around 100MB, and near-zero CPU overhead at idle. It is fully
      multi-threaded, supports both Java Edition and Bedrock Edition clients
      natively, and is free and open source software licensed under the GNU
      General Public License.
    '';
    homepage = "https://pumpkinmc.org/";
    changelog = "https://github.com/Pumpkin-MC/Pumpkin/commit/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    mainProgram = "pumpkin";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
  };
})
