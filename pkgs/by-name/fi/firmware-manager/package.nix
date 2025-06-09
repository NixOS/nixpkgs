{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo,
  pkg-config,
  rustc,
  openssl,
  udev,
  gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "firmware-manager";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "firmware-manager";
    rev = version;
    hash = "sha256-Q+LJJ4xK583fAcwuOFykt6GKT0rVJgmTt+zUX4o4Tm4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-LooE5jU4G1QHYTa/sB95W6VJs7lY7sjHI9scUaZRmq4=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace '$(DESTDIR)/etc' '$(DESTDIR)$(prefix)/etc'
  '';

  nativeBuildInputs = [
    cargo
    rustc
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    gtk3
    udev
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Graphical frontend for firmware management";
    homepage = "https://github.com/pop-os/firmware-manager";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    mainProgram = "com.system76.FirmwareManager";
    maintainers = [ lib.maintainers.shlevy ];
    platforms = lib.platforms.linux;
  };
}
