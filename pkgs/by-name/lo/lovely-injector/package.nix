{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  writeShellScript,
  cmake,
}:
let
  version = "0.8.0";
in
rustPlatform.buildRustPackage {
  pname = "lovely-injector";
  inherit version;
  src = fetchFromGitHub {
    owner = "ethangreen-dev";
    repo = "lovely-injector";
    tag = "v${version}";
    hash = "sha256-leTe7j4RTqc6BkiS7W5e0viK8FEwJpPLNoyf4GLOI3E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-MnXB2ho48VPYtFSnGHGkuSv1eprOhmj4wMG2YmFSGec=";
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
  ];

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
    platforms = [ "x86_64-linux" ];
  };
}
