{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
let
  version = "0.7.1";
  lovelyInjector = fetchFromGitHub {
    owner = "vgskye";
    repo = "lovely-injector";
    rev = "5dde1ff2647683d3c7fed748146720c30cc69826";
    hash = "sha256-j03/DOnLFfFYTwGGh+7BalS779jyg+p0UqtcTTyHgv4=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lovely-injector";
  inherit version;
  src = lovelyInjector;
  useFetchCargoVendor = true;
  cargoHash = "sha256-hHq26kSKcqEldxUb6bn1laTpKGFplP9/2uogsal8T5A=";
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
