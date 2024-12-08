{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  dbus,
  hidapi,
  udev,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dualsensectl";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "dualsensectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wu3TcnHoMZELC7I2PlE8z00+CycgpNd6SiZd5MjYD+I=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/" "/"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    hidapi
    udev
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

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
