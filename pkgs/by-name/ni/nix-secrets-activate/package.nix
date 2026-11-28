{
  lib,
  makeBinaryWrapper,
  symlinkJoin,
  callPackage,
  nix-secrets-activate-unwrapped,
  # TODO: https://github.com/unnamed-systems/nix-secrets/issues/40
  age,
  extraPackages ? [ age ],
}:
let
  wrapperArgs = lib.optionals (extraPackages != [ ]) [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath extraPackages)
  ];
in
symlinkJoin {
  pname = "nix-secrets-activate";
  inherit (nix-secrets-activate-unwrapped) version;
  __structuredAttrs = true;
  strictDeps = true;

  paths = [ nix-secrets-activate-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = lib.optionalString (wrapperArgs != [ ]) ''
    wrapProgram "$out/bin/${nix-secrets-activate-unwrapped.meta.mainProgram}" ${lib.escapeShellArgs wrapperArgs}
  '';

  passthru.unwrapped = nix-secrets-activate-unwrapped;

  meta = {
    # Manually inherit fields to keep `meta.position` pointing to this file.
    inherit (nix-secrets-activate-unwrapped.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
