{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libGL,
  libxkbcommon,
  u-config,
  wayland,
  wayland-protocols,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "asr-debugger";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = "asr-debugger";
    tag = finalAttrs.version;
    hash = "sha256-8rZX2zFfafkdx+eIYGb8GwBhjTBO/FpWf9elXp9Ad0Y=";
  };

  cargoHash = "sha256-ju+IAn2s1u/UwYwECBD7gHCDX3PidcjMiwvXp4SFZnc=";

  addDlopenRunpaths = map (p: "${lib.getLib p}/lib") (
    lib.optionals stdenv.hostPlatform.isLinux [
      libxkbcommon
      wayland
      libGL
    ]
  );

  addDlopenRunpathsPhase = ''
    elfHasDynamicSection() {
        patchelf --print-rpath "$1" >& /dev/null
    }

    while IFS= read -r -d $'\0' path ; do
      elfHasDynamicSection "$path" || continue
      for dep in $addDlopenRunpaths ; do
        patchelf "$path" --add-rpath "$dep"
      done
    done < <(
      for o in $(getAllOutputNames) ; do
        find "''${!o}" -type f -and "(" -executable -or -iname '*.so' ")" -print0
      done
    )
  '';

  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  doInstallCheck = true;

  meta = {
    description = "A debugger for LiveSplit One's new Auto Splitting Runtime.";
    homepage = "https://github.com/LiveSplit/asr-debugger";
    changelog = "https://github.com/LiveSplit/asr-debugger/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      abus-sh
    ];
    mainProgram = "asr-debugger";
  };
})
