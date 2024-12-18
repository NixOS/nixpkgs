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
  version = "0.5";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "dualsensectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+OSp9M0A0J4nm7ViDXG63yrUZuZxR7gyckwSCdy3qm0=";
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
