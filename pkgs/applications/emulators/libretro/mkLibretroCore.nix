{
  # Deps
  lib,
  stdenv,
  makeWrapper,
  retroarch-bare,
  unstableGitUpdater,
  zlib,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "core"
    "extraBuildInputs"
    "extraNativeBuildInputs"
    "includeRetroArch"
    "libretroCore"
    "normalizeCore"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      core,
      enableParallelBuilding ? true,
      extraBuildInputs ? [ ],
      extraNativeBuildInputs ? [ ],
      makeFlags ? [ ],
      makefile ? "Makefile.libretro",
      meta ? { },
      passthru ? { },
      strictDeps ? true,
      ## Location of resulting RetroArch core on $out
      libretroCore ? "/lib/retroarch/cores",
      ## The core filename is derived from the core name
      ## Setting `normalizeCore` to `true` will convert `-` to `_` on the core filename
      normalizeCore ? true,
      ## Whether to include a wrapper script which launches this core with RetroArch
      includeRetroArch ? true,
      ...
    }:
    let
      d2u = if normalizeCore then (lib.replaceStrings [ "-" ] [ "_" ]) else (x: x);
      coreDir = placeholder "lib" + libretroCore;
      coreFilename = "${d2u core}_libretro${stdenv.hostPlatform.extensions.sharedLibrary}";
      mainProgram = "retroarch-${core}";
    in
    {
      pname = "libretro-${core}";

      buildInputs = [ zlib ] ++ extraBuildInputs;
      nativeBuildInputs = lib.optional finalAttrs.includeRetroArch makeWrapper ++ extraNativeBuildInputs;

      outputs = [
        "lib"
        "out"
      ];

      inherit
        enableParallelBuilding
        includeRetroArch
        makefile
        strictDeps
        ;

      makeFlags = [
        "platform=${
          {
            linux = "unix";
            darwin = "osx";
            windows = "win";
          }
          .${stdenv.hostPlatform.parsed.kernel.name} or stdenv.hostPlatform.parsed.kernel.name
        }"
        "ARCH=${
          {
            armv7l = "arm";
            armv6l = "arm";
            aarch64 = "arm64";
            i686 = "x86";
          }
          .${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name
        }"
      ]
      ++ makeFlags;

      installPhase = ''
        runHook preInstall

        install -Dt ${coreDir} ${coreFilename}
      ''
      + lib.optionalString finalAttrs.includeRetroArch ''
        makeWrapper ${retroarch-bare}/bin/retroarch $out/bin/${mainProgram} \
          --add-flags "-L ${coreDir}/${coreFilename}"
      ''
      + ''

        runHook postInstall
      '';

      passthru = {
        inherit core libretroCore;
        # libretro repos sometimes has a fake tag like "Current", ignore
        # it by setting hardcodeZeroVersion
        updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
      }
      // passthru;

      meta = {
        inherit (retroarch-bare.meta) platforms;
        teams = [ lib.teams.libretro ];
      }
      // lib.optionalAttrs finalAttrs.includeRetroArch { inherit mainProgram; }
      // meta;
    };
}
