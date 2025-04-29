{
  lib,
  fetchFromGitHub,
  rustPlatform,
  atomic-browser,
  nix-update-script,
  nasm,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atomic-server";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "atomicdata-dev";
    repo = "atomic-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iZRKgRQL/+6RavFMWEugpd8+sWgXgE+itqak5BZe51s=";
  };

  cargoHash = "sha256-Lf3IjITpfAhPAznUNZyl1WJtWxNUmySPlzvsPHl7t68=";

  postUnpack = ''
    mkdir -p source/server/assets_tmp
    cp -r ${atomic-browser}/* source/server/assets_tmp
  '';

  inputsFrom = [ atomic-browser ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ nasm ];

  meta = {
    description = "Reference implementation for the Atomic Data specification";
    homepage = "https://docs.atomicdata.dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "atomic-server";
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.oluchitheanalyst ];
  };
})
