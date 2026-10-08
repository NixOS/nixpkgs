{
  lib,
  stdenv,
  buildVscode,
  fd,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:
let
  info =
    (lib.importJSON ./info.json)."${stdenv.hostPlatform.system}"
      or (throw "windsurf: unsupported system ${stdenv.hostPlatform.system}");
in
(buildVscode {
  inherit commandLineArgs useVSCodeRipgrep;

  inherit (info) version vscodeVersion;

  pname = "devin-desktop";

  executableName = "devin-desktop";
  longName = "devin-desktop";
  shortName = "devin-desktop";
  libraryName = "devin-desktop";
  iconName = "devin-desktop";

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Devin.app" else "Devin";

  src = fetchurl { inherit (info) url sha256; };

  tests = nixosTests.vscodium;

  updateScript = ./update/update.mts;

  # Editing the `codium` binary (and shell scripts) within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because VSCodium is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Agentic IDE powered by AI Flow paradigm";
    longDescription = ''
      The first agentic IDE, and then some.
      Devin Desktop is where the work of developers and AI truly flow together, allowing for a coding experience that feels like literal magic.
    '';
    homepage = "https://devin.ai/desktop";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sarahec
      xiaoxiangmoe
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  (oldAttrs: {
    # Run patchelf manually *before* restoring the staticaly linked binaries
    dontAutoPatchelf = stdenv.hostPlatform.isLinux;

    runtimeDependencies =
      (oldAttrs.runtimeDependencies or [ ])
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        fd
      ];

    # devin-desktop ships statically-linked relocatable binaries;`patchelf --set-rpath` corrupts the self-relocation bootstrap,
    # causing SIGSEGV. Since the autoPatchElfHook fires after postFixup, we need to disable it and patch before we replace the files.
    postFixup =
      (oldAttrs.postFixup or "")
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        autoPatchelf -- "$out"
        echo "Restoring static binaries"
        cp ./resources/app/extensions/windsurf/devin/bin/devin "$out/lib/devin-desktop/resources/app/extensions/windsurf/devin/bin/devin"
        cp ./resources/app/extensions/windsurf/bin/language_server_linux_x64 "$out/lib/devin-desktop/resources/app/extensions/windsurf/bin/language_server_linux_x64"

        ln -sf "${lib.getExe fd}" "$out/lib/devin-desktop/resources/app/extensions/windsurf/bin/fd"
      '';
  })
