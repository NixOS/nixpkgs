{
  autoPatchelfHook,
  capDacOverrideWrapperDir,
  espanso,
  patchelfUnstable, # have to use patchelfUnstable to support --rename-dynamic-symbols
  stdenv,
}:
let
  inherit (espanso) version;
  pname = "${espanso.pname}-capdacoverride";

  wrapperLibName = "wrapper-lib.so";

  # On Wayland, Espanso requires the DAC_OVERRIDE capability. One can create a wrapper binary with this
  # capability using the `config.security.wrappers.<name>` framework. However, this is not enough: the
  # capability is required by a worker process of Espanso created by forking `/proc/self/exe`, which points
  # to the executable **without** the DAC_OVERRIDE capability. Thus, we inject a wrapper library into Espanso
  # that redirects requests to `/proc/self/exe` to the binary with the proper capabilities.
  wrapperLib = stdenv.mkDerivation {
    name = "${pname}-${version}-wrapper-lib";

    dontUnpack = true;

    postPatch = ''
      substitute ${./wrapper-lib.c} lib.c --subst-var-by to "${capDacOverrideWrapperDir}/espanso-wayland"
    '';

    buildPhase = ''
      runHook preBuild
      cc -fPIC -shared lib.c -o ${wrapperLibName}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -D -t $out/lib ${wrapperLibName}
      runHook postInstall
    '';
  };
in
espanso.overrideAttrs (previousAttrs: {
  inherit pname;

  buildInputs = previousAttrs.buildInputs ++ [ wrapperLib ];

  nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
    autoPatchelfHook
    patchelfUnstable
  ];

  postInstall =
    ''
      echo readlink readlink_wrapper > readlink_name_map
      patchelf \
        --rename-dynamic-symbols readlink_name_map \
        --add-needed ${wrapperLibName} \
        "$out/bin/espanso"
    ''
    + previousAttrs.postInstall;
})
