{
  lib,
  fetchFromGitHub,
  flutter,
  stdenv,
  fetchzip,
}:
let
  pname = "butterfly";
  version = "2.2.1";
  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    rev = "v${version}";
    hash = "sha256-TV7C0v3y9G44Df/x1ST8D0c0QqNBuuhzPBMKUyf/iwo=";
  };
  pdfium-binaries = fetchzip {
    url = "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/5200/pdfium-linux-x64.tgz";
    hash = "sha256-AJop6gKjF/DPgItuPQsWpgngxiqVNeqBbhHZz3aQ1n0=";
    stripRoot = false;
  };
in
flutter.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  customSourceBuilders = {
    printing =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "printing";
        inherit version src;
        inherit (src) passthru;
        patches = [ ./printing.patch ];
        installPhase = ''
          runHook preInstall
          mkdir $out
          cp -a ./* $out/
          runHook postInstall
        '';
      };
  };

  env.PDFIUM_DIR = "${pdfium-binaries}";

  gitHashes = {
    dart_leap = "sha256-eEyUqdVToybQoDwdmz47H0f3/5zRdJzmPv1d/5mTOgA=";
    lw_file_system = "sha256-CPBwaDTK57SKcaD4IzjIL4cWixEDK9sv3zCDeNfFpw0=";
    flutter_secure_storage_web = "sha256-ULYXcFjz9gKMjw1Q1KAmX2J7EcE8CbW0MN/EnwmaoQY=";
    networker = "sha256-8ol5YRim4dLpgR30DXbgHzq+VDk1sPLIi+AxUtwOls8=";
    lw_file_system_api = "sha256-OOLbqKLvgHUJf3LiiQoHJS6kngnWtHPhswM69sX5fwE=";
    lw_sysapi = "sha256-9hCAYB5tqYKQPHGa7+Zma6fE8Ei08RvyL9d65FMuI+I=";
    flex_color_scheme = "sha256-MYEiiltevfz0gDag3yS/ZjeVaJyl1JMS8zvgI0k4Y0k=";
    material_leap = "sha256-pQ+OvecHaav5QI+Hf7+DDcXYM3JMwogseMzce1ULveY=";
    networker_socket = "sha256-+h5FXqPhB6VJ269WPoqKk+/1cE+p7UbLvDwnXrJh+CE=";
    perfect_freehand = "sha256-dMJ8CyhoQWbBRvUQyzPc7vdAhCzcAl1X7CcaT3u6dWo=";
  };

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

  meta = {
    description = "Powerful, minimalistic, cross-platform, opensource note-taking app";
    homepage = "https://github.com/LinwoodDev/Butterfly";
    mainProgram = "butterfly";
    license = with lib.licenses; [
      agpl3Plus
      cc-by-sa-40
      asl20 # pdfium-binaries
    ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # pdfium-binaries
    ];
  };
}
