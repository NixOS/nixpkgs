{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  meson,
  ninja,
  pkg-config,
  dbus,
  hidapi,
  udev,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dualsensectl";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "dualsensectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/EPFZWpa7U4fmcdX2ycFkPgaqlKEA2cD84LBkcvVVhc=";
  };

  nativeBuildInputs = [
    installShellFiles
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    hidapi
    udev
  ];

  postInstall = ''
    installShellCompletion --cmd dualsensectl \
      --bash ../completion/dualsensectl \
      --zsh ../completion/_dualsensectl
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    changelog = "https://github.com/nowrep/dualsensectl/releases/tag/v${finalAttrs.version}";
    description = "Linux tool for controlling PS5 DualSense controller";
    homepage = "https://github.com/nowrep/dualsensectl";
    license = licenses.gpl2Only;
    mainProgram = "dualsensectl";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.linux;
  };
})
