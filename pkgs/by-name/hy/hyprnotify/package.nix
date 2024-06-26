{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, alsa-lib
}:

buildGoModule rec {
  pname = "hyprnotify";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "codelif";
    repo = "hyprnotify";
    rev = "v${version}";
    hash = "sha256-dAclsaY8gjHFyWe1/df98Tz5a1tJTZz2xvx8CZv1Q6Q=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsa-lib
  ];

  vendorHash = "sha256-AZDtaiSNq7em876Q9f+YeDxboqVwA8IE9dDM6zggFXs=";

  ldflags = [ "-s" "-w" ];

  meta =  {
    description = "DBus Implementation of Freedesktop Notification spec for 'hyprctl notify";
    homepage = "https://github.com/codelif/hyprnotify";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fedx-sudo ];
    mainProgram = "hyprnotify";
  };
}

