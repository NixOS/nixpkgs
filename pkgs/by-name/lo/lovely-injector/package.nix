{
  lib,
  fetchFromGitHub,
  rustPlatform,

  cmake,
  pkg-config,

  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lovely-injector";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ethangreen-dev";
    repo = "lovely-injector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KHpBla3B6JoC8cPue1cG2EosTH4hs7idlTdh/e1BIX0=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-W9P7bdPSHpSUeCshr7ZXPFI8fh4c7uq+K2DsWBFiSfU=";
  cargoBuildFlags = [
    "--package"
    "lovely-unix"
  ];

  # no tests
  doCheck = false;
  # lovely-injector depends on nightly rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ zstd ];

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
    maintainers = with lib.maintainers; [
      antipatico
      ryand56
    ];
    platforms = [ "x86_64-linux" ];
  };
})
