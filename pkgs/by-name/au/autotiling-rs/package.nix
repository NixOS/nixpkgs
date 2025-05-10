{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "autotiling-rs";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${version}";
    sha256 = "sha256-LQbmF2M6pWa0QEbKF770x8TFLMGrJeq5HnXHvLrDDPA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-s2r8517RgcMq+6S2M+gTI7a+C4AhxIkDOHG0XjRI4rI=";

  meta = with lib; {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "autotiling-rs";
  };
}
