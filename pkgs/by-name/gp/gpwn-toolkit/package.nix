{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpwn-toolkit";
  version = "0.1.0-unstable-2026-08-20";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gpwn-org";
    repo = "gpwn-toolkit";
    rev = "a5a03958097d54f7e91b9c39393a4bb7d2bc88ba";
    hash = "sha256-xe8glMrzS7xpx+xQStxJIl5vxvsVvj1cHSx1QWx2sHk=";
  };

  cargoHash = "sha256-bPBOYLpQ97kzcOJe9jl2lP6lhDcj/HscWquYbhdDNSU=";

  nativeBuildInputs = [ perl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Collection of libraries and a TUI to test fiber GPON deployments";
    homepage = "https://github.com/gpwn-org/gpwn-toolkit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "gpwn-tui";
  };
})
