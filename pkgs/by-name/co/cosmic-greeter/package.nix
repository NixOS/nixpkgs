{
  cmake,
  coreutils,
  fetchFromGitHub,
  just,
  lib,
  libcosmicAppHook,
  libinput,
  linux-pam,
  rustPlatform,
  stdenv,
  udev,
  xkeyboard_config,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-greeter";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-H7ieV+urShGOdyJtz3DVD4aFmV8nNMnyDAL/XxopPl4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9pI3eepuZUPapsG/xffh0xaK4XZJ11sdjOc6EJDu/n0=";

  nativeBuildInputs = [
    cmake
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "--all" ];
  buildInputs = [
    libinput
    linux-pam
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter"
    "--set"
    "daemon-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter-daemon"
  ];

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-greeter";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
