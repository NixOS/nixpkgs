{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  callPackage,
  esbuild,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fider";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "getfider";
    repo = "fider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nzOplwsE0ppmxbTrNAgePnIQIAD/5Uu4gXlebFKWGfc=";
  };

  dontConfigure = true;
  dontBuild = true;

  # Allow easier version overrides, e.g.:
  # pkgs.fider.overrideAttrs (prev: {
  #   version = "...";
  #   src = prev.src.override {
  #     hash = "...";
  #   };
  #   vendorHash = "...";
  #   npmDepsHash = "...";
  # })
  vendorHash = "sha256-CfopU72fpXiTaBtdf9A57Wb+flDu2XEtTISxImeJLL0=";
  npmDepsHash = "sha256-gnboT5WQzftOCZ2Ouuza7bqpxJf+Zs7OWC8OHMZNHvw=";

  server = callPackage ./server.nix {
    inherit (finalAttrs)
      pname
      version
      src
      vendorHash
      ;
  };
  frontend = callPackage ./frontend.nix {
    inherit (finalAttrs)
      pname
      version
      src
      npmDepsHash
      ;
    # We specify the esbuild override here instead of in frontend.nix so end users can
    # again easily override it if necessary, for example when changing to an unreleased
    # version of fider requiring a newer esbuild than specified here:
    # pkgs.fider.overrideAttrs (prev: {
    #   frontend = prev.frontend.override {
    #     esbuild = ...;
    #   };
    # })
    esbuild = esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.14.38";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              tag = "v${version}";
              hash = "sha256-rvMi1oC7qGidvi4zrm9KCMMntu6LJGVOGN6VmU2ivQE=";
            };
            vendorHash = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";
          }
        );
    };
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc
    cp -r locale views migrations $out/
    cp -r etc/*.md $out/etc/
    ln -s ${finalAttrs.server}/* $out/
    ln -s ${finalAttrs.frontend}/* $out/

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) fider;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open platform to collect and prioritize feedback";
    homepage = "https://github.com/getfider/fider";
    changelog = "https://github.com/getfider/fider/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    mainProgram = "fider";
    maintainers = with lib.maintainers; [
      drupol
      niklaskorz
    ];
  };
})
