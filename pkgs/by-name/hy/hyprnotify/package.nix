{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  alsa-lib
}:

buildGoModule rec {
  pname = "hyprnotify";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "codelif";
    repo = "hyprnotify";
    rev = "v${version}";
    hash = "sha256-+vBOHXaCWEoQ/Lk9VwP55XqlhSzSS9hoVg4FQOj8dIU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  vendorHash = "sha256-2BuWJ57jELtfj7SGr+dLdC2KFc5sD2bC8MgjUHaIXUs=";

  meta = {
    description = "DBus Implementation of Freedesktop Notification spec for 'hyprctl notify'";
    homepage = "https://github.com/codelif/hyprnotify";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bloeckchengrafik ];
    mainProgram = "hyprnotify";
  };
}
