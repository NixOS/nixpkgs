{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:
let
  pname = "paperlib";
  version = "3.1.6";
  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "https://github.com/Future-Scholars/paperlib/releases/download/release-electron-${version}/Paperlib_${version}.dmg";
          hash = "sha256-d9vEFx59K15PO7DJYJQ2fjiagqa8oJLtoawILDF9IKc=";
        };
        x86_64-linux = {
          url = "https://github.com/Future-Scholars/paperlib/releases/download/release-electron-${version}/Paperlib_${version}.AppImage";
          hash = "sha256-2xbn9UWlcf37n9jZdZKyyevzsag6SW9YuQH/bYCRmLQ=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  passthru = {
    inherit pname version src;
  };

  meta = {
    homepage = "https://github.com/Future-Scholars/paperlib?";
    description = "Open-source academic paper management tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "paperlib";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      mv Paperlib.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    extraPkgs = pkgs: [ pkgs.libsecret ];
  }
