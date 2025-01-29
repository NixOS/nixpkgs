{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "clock-rs";
  version = "0.1.213";

  src = fetchFromGitHub {
    owner = "Oughie";
    repo = "clock-rs";
    tag = "v${version}";
    sha256 = "06spnadlgy7902bqhhi6019ay5y55qfrarsfidp938icali9q5pi";
  };

  cargoHash = "sha256-ir/IwhREheMSdElLYqp3/zHE54BMAK5/7f5/wyTd1yc=";

  meta = {
    description = "Modern, digital clock that effortlessly runs in your terminal";
    longDescription = ''
      clock-rs is a terminal-based clock written in Rust, designed to be a new alternative to tty-clock.
      It supports all major platforms and offers several improvements, which include:

      The use of a single configuration file to manage its settings, with the ability to overwrite them through the command line,
      Many additional features such as a timer and a stopwatch,
      And greater flexibility as well as better user experience!
    '';
    homepage = "https://github.com/Oughie/clock-rs";
    license = lib.licenses.asl20;
    mainProgram = "clock-rs";
    maintainers = [ lib.maintainers.oughie ];
    platforms = lib.platforms.all;
  };
}
