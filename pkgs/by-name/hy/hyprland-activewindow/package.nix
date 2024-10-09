{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-2pIOZMBPqheqAz3YEvHP2ehLXhqIclOXXAFa5EXXZPk=";
  };

  cargoHash = "sha256-5JhNBgP6VQX7TVPaFUGvknDWrn6F06Mm3mGfuajg9yQ=";

  meta = with lib; {
    description = "Multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-activewindow";
  };
}
