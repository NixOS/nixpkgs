{
  pname,
  version,
  outputs,
  meta,
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version outputs;

  src = fetchurl {
    url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
    sha256 = "sha256-CR96Kz9BYKFtfVKygiEku51XFJk4FfYqfXACeYQ3JlI=";
  };

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Ghostty.app $out/Applications/
    makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty

    runHook postInstall
  '';

  postFixup =
    let
      resources = "$out/Applications/Ghostty.app/Contents/Resources";
    in
    ''
      mkdir -p $man/share
      ln -s ${resources}/man $man/share/man

      mkdir -p $terminfo/share
      ln -s ${resources}/terminfo $terminfo/share/terminfo

      mkdir -p $shell_integration
      for folder in "${resources}/ghostty/shell-integration"/*; do
        ln -s $folder $shell_integration/$(basename "$folder")
      done

      mkdir -p $vim
      for folder in "${resources}/vim/vimfiles"/*; do
        ln -s $folder $vim/$(basename "$folder")
      done
    '';

  meta = meta // {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
