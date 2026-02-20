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
}:

stdenv.mkDerivation rec {
  pname = "winetricks";
  version = src.version;

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
    inherit (src) updateScript;
  };

  meta = {
    description = "Script to install DLLs needed to work around problems in Wine";
    mainProgram = "winetricks";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/Winetricks/winetricks";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
