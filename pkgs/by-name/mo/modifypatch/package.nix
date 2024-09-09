# This normalizes a patch/diff file.

{
  stdenvNoCC,
  lib,
  patchutils,
  modifypatchscript,
}:

{
  src,
  name ? null,
  nativeBuildInputs ? [ ],
  preModify ? "",
  postModify ? "",
  derivationArgs ? { },

  relative ? null,
  stripLen ? 0,
  decode ? "cat", # custom command to decode patch e.g. base64 -d
  extraPrefix ? null,
  excludes ? [ ],
  includes ? [ ],
  revert ? false,
}:
stdenvNoCC.mkDerivation (
  {
    inherit src;
    passAsFile = [ "src" ];

    name = if name != null then name else builtins.baseNameOf (builtins.toString src);

    enableParallelBuilding = true;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ patchutils ] ++ nativeBuildInputs;
    installPhase = ''
      runHook preInstall
      ${preModify}

      ${modifypatchscript {
        inherit
          relative
          stripLen
          decode
          extraPrefix
          excludes
          includes
          revert
          ;
      }}

      ${postModify}
      runHook postInstall
    '';
  }
  // lib.optionalAttrs (!derivationArgs ? meta) {
    pos =
      let
        argNames = builtins.attrNames derivationArgs;
      in
      if builtins.length argNames > 0 then
        builtins.unsafeGetAttrPos (builtins.head argNames) derivationArgs
      else
        null;
  }
  // derivationArgs
)
