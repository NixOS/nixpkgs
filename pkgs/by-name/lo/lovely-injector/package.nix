{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
let
  version = "0.6.0";
  lovelyInjector = fetchFromGitHub {
    owner = "vgskye";
    repo = "lovely-injector";
    rev = "3224915f4d47b557c34b5012797cf92d4cc629af";
    hash = "sha256-fzkuuu6pmvqeJa7qlX8jhtCLC4oYRLUm1hqHTRiYEX8=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lovely-injector";
  inherit version;
  src = lovelyInjector;
  useFetchCargoVendor = true;
  cargoHash = "sha256-Mkmj+ENdUge1V1cVAQOV2K01sYKEyhxTse0f5o6H6Xc=";
  # no tests
  doCheck = false;
  # lovely-injector depends on nightly rust features
  env.RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "Runtime lua injector for games built with LÖVE";
    longDescription = ''
      Lovely is a lua injector which embeds code into a LÖVE 2d game at runtime.
      Unlike executable patchers, mods can be installed, updated, and removed over and over again without requiring a partial or total game reinstallation.
      This is accomplished through in-process lua API detouring and an easy to use (and distribute) patch system.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/ethangreen-dev/lovely-injector";
    downloadPage = "https://github.com/ethangreen-dev/lovely-injector/releases";
    maintainers = [ lib.maintainers.antipatico ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
