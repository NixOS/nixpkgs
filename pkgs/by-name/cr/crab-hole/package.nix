{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crab-hole";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "LuckyTurtleDev";
    repo = "crab-hole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ss+jsYjM/hxTWMTDV7+o+C+tB8Wiz2UuIZcdxUAl+O0=";
  };

  cargoHash = "sha256-v8uoP3qJbbeDAAiBHGGUKus+nv16rq2WOx1YeKlNgL8=";

  meta = {
    description = "Pi-Hole clone written in Rust using Hickory DNS";
    homepage = "https://github.com/LuckyTurtleDev/crab-hole";
    license = lib.licenses.agpl3Plus;
    mainProgram = "crab-hole";
    maintainers = [
      lib.maintainers.NiklasVousten
    ];
    platforms = lib.platforms.linux;
  };
})
