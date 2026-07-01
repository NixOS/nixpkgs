{
  lib,
  haskell,
  haskellPackages,
  fetchFromGitHub,
  installShellFiles,
}:

let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  raw = haskellPackages.callPackage (
    {
      mkDerivation,
      async,
      base,
      containers,
      directory,
      filepath,
      mtl,
      optparse-applicative,
      process,
      stm,
      text,
      unix,
    }:
    mkDerivation {
      pname = "repoconductor";
      version = "1.4.0";
      src = fetchFromGitHub {
        owner = "shichirouji21";
        repo = "RepoConductor";
        rev = "v1.4.0";
        hash = "sha256-kUUxfscSwgd6xFFyWxVSzrkuyzXWIvyon6CRTZHclg8=";
      };
      isLibrary = false;
      isExecutable = true;
      executableHaskellDepends = [
        async
        base
        containers
        directory
        filepath
        mtl
        optparse-applicative
        process
        stm
        text
        unix
      ];
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [ shichirouji21 ];
      mainProgram = "repoconductor";
      description = "Terminal dashboard for managing multiple git repositories";
      homepage = "https://github.com/shichirouji21/RepoConductor";
      changelog = "https://github.com/shichirouji21/RepoConductor/blob/v1.4.0/CHANGELOG.md";
    }
  ) { };

  withCompletions = overrideCabal (drv: {
    buildTools = (drv.buildTools or [ ]) ++ [ installShellFiles ];
    postInstall = (drv.postInstall or "") + ''
      installShellCompletion --cmd repoconductor \
        --bash $src/completions/repoconductor.bash \
        --zsh  $src/completions/_repoconductor \
        --fish $src/completions/repoconductor.fish
    '';
  }) raw;
in
(justStaticExecutables withCompletions).overrideAttrs (_oldAttrs: {
  strictDeps = true;
  __structuredAttrs = true;
})
