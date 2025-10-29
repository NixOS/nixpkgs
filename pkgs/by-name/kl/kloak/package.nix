{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libevdev,
  libinput,
  libxkbcommon,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "kloak";
  version = "0.5.6-1";

  src = fetchFromGitHub {
    owner = "Whonix";
    repo = "kloak";
    tag = version;
    hash = "sha256-ddSfEnEp7E+hZTrYXghv1Tf/u6dbx4pp/cUOS6Ksje0=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libevdev
    libinput
    libxkbcommon
    wayland
  ];

  # Skip the pkg-config check in the Makefile since we know it's available
  preBuild = ''
    # The Makefile uses 'which' to check for pkg-config, but we don't need this check
    # since Nix guarantees pkg-config is available via nativeBuildInputs
    substituteInPlace Makefile \
      --replace-fail 'ifeq (, $(shell which $(PKG_CONFIG)))' 'ifeq (, )' \
      --replace-fail '$(error pkg-config not installed!)' ""
  '';

  installFlags = [
    "prefix=$(out)"
    "apparmor_dir=$(out)/etc/apparmor.d"
  ];

  meta = {
    description = "Keystroke-level online anonymization kernel that obfuscates typing behavior";
    longDescription = ''
      kloak is a privacy tool that makes keystroke biometrics less effective.
      This is accomplished by obfuscating the time intervals between key press
      and release events, which are typically used to identify users based on
      their typing behavior.
    '';
    homepage = "https://github.com/Whonix/kloak";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hydrafog ];
    mainProgram = "kloak";
    platforms = lib.platforms.linux;
  };
}
