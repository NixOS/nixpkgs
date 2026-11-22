{
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  bash,
  cabextract,
  coreutils,
  curl,
  gawk,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  p7zip,
  perl,
  unzip,
  which,
  zenity,
  unrar-free,
  versionCheckHook,
  runCommand,
  wineWow64Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "winetricks";
  version = finalAttrs.src.version;

  src = (callPackage ./sources.nix { }).winetricks;

  buildInputs = [
    perl
    which
    makeWrapper
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false; # requires "bashate"

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postPatch = ''
    patchShebangs src/winetricks
    substituteInPlace src/winetricks \
      --replace-fail 'command -v unrar' 'command -v unrar-free' \
      --replace-fail 'w_try unrar' 'w_try unrar-free'
  '';

  postInstall =
    let
      runtimeDependencies = [
        bash
        cabextract
        coreutils
        curl
        gawk
        gnugrep
        gnused
        gnutar
        gzip
        p7zip
        perl
        unrar-free
        unzip
        which
        zenity
      ];
    in
    ''
      wrapProgram $out/bin/winetricks \
        --prefix PATH : "${lib.makeBinPath runtimeDependencies}" \
        --set WINETRICKS_LATEST_VERSION_CHECK "disabled"
    '';

  passthru = {
    inherit (finalAttrs.src) updateScript;
    # winetricks detects the WoW64 style only in 64-bit prefixes, and only
    # the *Full variants wrap `wine`.
    tests =
      let
        testWith =
          name: wine:
          runCommand "winetricks-test-${name}"
            {
              nativeBuildInputs = [
                finalAttrs.finalPackage
                wine
              ];
            }
            ''
              export HOME=$TMPDIR/home WINEPREFIX=$TMPDIR/prefix WINEDEBUG=-all
              export WINEDLLOVERRIDES="mscoree=;mshtml=;winemenubuilder.exe=d"
              mkdir -p "$HOME"
              # a fresh prefix already reports Windows 10, so apply win7
              winetricks win7 2>&1 | tee log
              grep -F "new wow64 mode" log
              wine reg query 'HKLM\Software\Microsoft\Windows NT\CurrentVersion' /v CurrentBuild \
                | tr -d '\r' | grep 7601
              wineserver -w
              touch $out
            '';
      in
      lib.optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
        wow64-minimal = testWith "wow64-minimal" wineWow64Packages.minimal;
        wow64-full = testWith "wow64-full" wineWow64Packages.full;
      };
  };

  meta = {
    description = "Script to install DLLs needed to work around problems in Wine";
    mainProgram = "winetricks";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/Winetricks/winetricks";
    maintainers = with lib.maintainers; [ ferris-qq ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
