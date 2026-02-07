{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  pkgsi686Linux,

  sourcesJson ? ./sources.json,
  inputs ? builtins.mapAttrs (name: info: fetchFromGitHub info) (lib.importJSON sourcesJson),

  millennium-python ? pkgsi686Linux.python311,
  millennium-shims ? callPackage ./shims.nix { inherit (inputs) millennium-src; },
  millennium-assets ? callPackage ./assets.nix { inherit (inputs) millennium-src; },
  millennium-frontend ? callPackage ./frontend.nix { inherit (inputs) millennium-src; },

  millennium-64 ? (callPackage ./millennium-64.nix { inherit inputs; }),

  millennium-32 ? (
    callPackage ./millennium-32.nix {
      inherit
        inputs
        millennium-shims
        millennium-frontend
        millennium-python
        ;
    }
  ),
}:
stdenv.mkDerivation {
  pname = "millennium";
  version = "2.34.0";

  phases = [
    "installPhase"
    "fixupPhase"
  ];

  installPhase = ''
    mkdir -p $out/lib

    echo "Merging 32-bit libraries..."
    cp -v ${millennium-32}/lib/*.so $out/lib/

    echo "Merging 64-bit libraries..."
    cp -v ${millennium-64}/lib/*.so $out/lib/
  '';

  passthru = {
    assets = millennium-assets;
    shims = millennium-shims;
    frontend = millennium-frontend;
    python = millennium-python;
  };

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Modding framework to create, manage and use themes/plugins for Steam";

    longDescription = "An open-source low-code modding framework to create, manage and use themes/plugins for the desktop Steam Client without any low-level internal interaction or overhead";

    maintainers = [
      lib.maintainers.trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
}
