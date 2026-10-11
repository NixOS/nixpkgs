{
  buildEnv,
  callPackage,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
  enableDeno ? false,
}:
let
  version = "0-unstable-2026-09-30";
  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-builder-tools";
    rev = "74697c75b630d7330e77250fc13cb5ea688d9479";
    hash = "sha256-yr6RTFN/ypqLPzagrjljnY9dhrin+bfbgzhsz3RY9ps=";
  };
in
buildEnv {
  inherit version;
  pname = "flatpak-builder-tools";

  paths = [
    (callPackage ./flatpak-cargo-generator.nix { inherit src version; })
    (callPackage ./flatpak-dotnet-generator.nix { inherit src version; })
    (callPackage ./flatpak-go-get-generator.nix { inherit src version; })
    (callPackage ./flatpak-gradle-generator.nix { inherit src version; })
    (callPackage ./flatpak-json2yaml.nix { inherit src version; })
    (callPackage ./flatpak-node-generator.nix { inherit src version; })
    (callPackage ./flatpak-pip-generator.nix { inherit src version; })
    (callPackage ./flatpak-poetry-generator.nix { inherit src version; })
  ]
  ++ lib.optionals enableDeno [
    (callPackage ./flatpak-deno-generator.nix { inherit src version; })
  ];

  pathsToLink = [ "/bin" ];

  derivationArgs = {
    inherit src;
    strictDeps = true;
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Collection of community-contributed scripts to assist with building applications using Flatpak Builder";
    homepage = "https://github.com/flatpak/flatpak-builder-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
  };
}
