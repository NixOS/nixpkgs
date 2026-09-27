{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clock-rs";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Oughie";
    repo = "clock-rs";
    tag = finalAttrs.version;
    hash = "sha256-mC7jZ0ZCSfjpF+p2TtNjt7oRowYkOujSkbuFzChYJ3U=";
  };

  cargoHash = "sha256-K5AdTjRz1GEWmbqW/D/7faYABUo71tpiyyOrCjHd1GM=";

  meta = {
    description = "Modern, digital clock that effortlessly runs in your terminal";
    longDescription = ''
      clock-rs is a terminal-based clock written in Rust, designed to be a new alternative to tty-clock.
      It supports all major platforms and offers several improvements, which include:

      - The use of a single configuration file to manage its settings, with the ability to override them through the command line,
      - Many additional features such as a timer and a stopwatch,
      - And greater flexibility as well as better user experience!
    '';
    homepage = "https://github.com/Oughie/clock-rs";
    license = lib.licenses.asl20;
    mainProgram = "clock-rs";
    maintainers = [ lib.maintainers.oughie ];
    platforms = lib.platforms.all;
  };
})
