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
  version = "staging-20261028";

  src = fetchFromGitHub {
    owner = "getpaseo";
    repo = "paseo-relay";
    tag = finalAttrs.version;
    hash = "sha256-F4PQg5vU9sI3d9XWukbINdBmhbfcehBzeUVxPKZ06Jg=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${finalAttrs.pname}";
    inherit (finalAttrs) src version;
    hash = "sha256-3J2C4XGqjdM0TYf+Vkv5/AY59tiKLVX81Gxrs9pvKuY=";
  };

  postInstall = ''
    mv $out/bin/paseo_relay $out/bin/paseo-relay
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A distributed, protocol-compatible relay for Paseo";
    homepage = "https://github.com/getpaseo/paseo-relay";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "paseo-relay";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
