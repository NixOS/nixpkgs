{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "applesauce";
  version = "0.5.18";

  src = fetchFromGitHub {
    owner = "Dr-Emann";
    repo = "applesauce";
    tag = "applesauce-cli-v${version}";
    hash = "sha256-Yl3oRgvpFIRRtuwCVQwMMndlROFsAOvKu/vb5ynKPLY=";
  };

  cargoHash = "sha256-d/D36krz3EKU1YTBZKcVVNYQISeYR+ohGpmaFNhfcCk=";

  meta = {
    description = "Transparent compression for Apple File System Compression (AFSC)";
    homepage = "https://github.com/Dr-Emann/applesauce";
    changelog = "https://github.com/Dr-Emann/applesauce/releases/tag/applesauce-cli-v${version}";
    license = with lib.licenses; [
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [
      maxicode
    ];
    mainProgram = "applesauce";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
