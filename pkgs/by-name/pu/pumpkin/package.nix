{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pumpkin";
  version = "0-unstable-2026-06-02";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Pumpkin-MC";
    repo = "Pumpkin";
    rev = "24e3b597121eda31cf25cc94e42cc4d823a94123";
    hash = "sha256-SQpsYI2YZ93xsDMr69vnuGwH+GsXMeEtZFacDmWsSHY=";
  };

  cargoHash = "sha256-9C90MdGbFEhminPvrZIqQ0o6nJPdO42Lqrxpl/sKUbs=";

  meta = {
    description = "Modern OSS Minecraft server in Rust";
    longDescription = ''
      Pumpkin is a server built from the ground-up. Its plugin system uses WebAssembly
      as a sandboxed plugin runtime. Unlike traditional JVM-based servers such as Vanilla, Spigot, or Paper,
      Pumpkin compiles to a single native executable with no Java runtime
      dependency, achieving startup times around 5 milliseconds, idle memory
      usage around 100MB, and near-zero CPU overhead at idle. It is fully
      multi-threaded, and supports both Java Edition and Bedrock Edition clients
      natively.
    '';
    homepage = "https://pumpkinmc.org/";
    changelog = "https://github.com/Pumpkin-MC/Pumpkin/commit/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    mainProgram = "pumpkin";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
