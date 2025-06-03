{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "bluewalker";
  version = "0.3.1";

  src = fetchFromGitLab {
    owner = "jtaimisto";
    repo = "bluewalker";
    rev = "v${version}";
    hash = "sha256-wAzBlCczsLfHboGYIsyN7dGwz52CMw+L3XQ0njfLVR0=";
  };

  vendorHash = "sha256-kHwj6FNWIonaHKy4QE0/UcuOfHAPE1al5nuYXrfROKE=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Simple command line Bluetooth LE scanner";
    homepage = "https://gitlab.com/jtaimisto/bluewalker";
    changelog = "https://gitlab.com/jtaimisto/bluewalker/-/tags/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ cimm ];
    platforms = lib.platforms.linux;
  };
}
