{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  alsa-lib
}:

buildGoModule rec {
  pname = "hyprnotify";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "codelif";
    repo = "hyprnotify";
    rev = "v${version}";
    hash = "sha256-dL+W+iMwRNw9042bs2XUFPMCCqIvDENXOMzhcLh+RL4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  vendorHash = "sha256-AZDtaiSNq7em876Q9f+YeDxboqVwA8IE9dDM6zggFXs=";

  meta = {
    description = "DBus Implementation of Freedesktop Notification spec for 'hyprctl notify'";
    homepage = "https://github.com/codelif/hyprnotify";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bloeckchengrafik ];
    mainProgram = "hyprnotify";
  };
}
