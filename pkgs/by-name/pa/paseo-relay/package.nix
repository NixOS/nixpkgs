{
  beamMinimal29Packages,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
let
  beamPackages = beamMinimal29Packages.overrideScope (
    final: prev: {
      elixir = final.elixir_1_20;
    }
  );
in
beamPackages.mixRelease (finalAttrs: {
  pname = "paseo-relay";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "getpaseo";
    repo = "paseo-relay";
    rev = "3fc41c96c8c63f3a7109e832899cc57d473c4531";
    hash = "sha256-53r3Mz1GCv5Vozbg02YfiGABn8HTvoao5R+4CxTKj3w=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${finalAttrs.pname}";
    inherit (finalAttrs) src version;
    hash = "sha256-3J2C4XGqjdM0TYf+Vkv5/AY59tiKLVX81Gxrs9pvKuY=";
  };

  postInstall = ''
    mv $out/bin/paseo_relay $out/bin/paseo-relay
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A distributed, protocol-compatible relay for Paseo";
    homepage = "https://github.com/getpaseo/paseo-relay";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "paseo-relay";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
