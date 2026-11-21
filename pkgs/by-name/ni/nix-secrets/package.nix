{
  lib,
  makeBinaryWrapper,
  symlinkJoin,
  callPackage,
  nix-secrets-unwrapped,
  nixBuildCommand ? null,
  # TODO: https://github.com/unnamed-systems/nix-secrets/issues/40
  age,
  extraPackages ? [ age ],
}:
let
  wrapperArgs =
    lib.optionals (extraPackages != [ ]) [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath extraPackages)
    ]
    ++ lib.optionals (nixBuildCommand != null) [
      "--set-default"
      "NIX_SECRETS_NIX_BUILD_COMMAND"
      nixBuildCommand
    ];
in
symlinkJoin {
  pname = "nix-secrets";
  inherit (nix-secrets-unwrapped) version;
  __structuredAttrs = true;
  strictDeps = true;

  paths = [ nix-secrets-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = lib.optionalString (wrapperArgs != [ ]) ''
    wrapProgram "$out/bin/${nix-secrets-unwrapped.meta.mainProgram}" ${lib.escapeShellArgs wrapperArgs}
  '';

  passthru.unwrapped = nix-secrets-unwrapped;

  meta = {
    # Manually inherit fields to keep `meta.position` pointing to this file.
    inherit (nix-secrets-unwrapped.meta)
      description
      homepage
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
