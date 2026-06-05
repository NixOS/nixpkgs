{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
  _7zz,
}:
let
  pname = "paperlib";
  version = "3.1.10";
  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/Future-Scholars/paperlib/releases/download/release-electron-${version}/Paperlib_${version}_arm.dmg";
          hash = "sha256-KNMPUeCNtODHzMJhCwI4SJPRfa87RmAe6CRRazgRZCQ=";
        };
        x86_64-darwin = {
          url = "https://github.com/Future-Scholars/paperlib/releases/download/release-electron-${version}/Paperlib_${version}.dmg";
          hash = "sha256-5QwF0+7Y4LzReHCj8yZrAJDAZVyY0ANC5gjAxdaVRkU=";
        };
        x86_64-linux = {
          url = "https://github.com/Future-Scholars/paperlib/releases/download/release-electron-${version}/Paperlib_${version}.AppImage";
          hash = "sha256-uBYhiUL4YWwnLLPvXMoXjlQqlqFep/OpwwnmPx7s5dY=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  passthru = {
    inherit pname version src;
  };

  meta = {
    homepage = "https://github.com/Future-Scholars/paperlib";
    description = "Open-source academic paper management tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = [
      "aarch64-darwin"
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

    nativeBuildInputs = if stdenv.hostPlatform.isAarch64 then [ _7zz ] else [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
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
