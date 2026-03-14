{
  callPackage,
  stdenv,
  ...
}@args:

let
  extraArgs = builtins.removeAttrs args [
    "callPackage"
    "stdenv"
  ];
in
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) extraArgs
