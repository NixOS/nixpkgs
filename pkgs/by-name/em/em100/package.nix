{
  curl,
  fetchgit,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "em100";
  version = "0-unstable-2024-11-14";

  src = fetchgit {
    url = "https://review.coreboot.org/em100";
    # No git tags available. Use latest rev from the main branch.
    rev = "a78b4ba4774f05ecd7af495604b437113596d70e";
    hash = "sha256-jzP56SMMiWiOynW17CFksi1VhpGt4oYYJrf4Rp9Vfs4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    libusb1
  ];

  buildFlags = [
    "em100"
    "makedpfw"
  ];

  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 em100 $out/bin/em100
    install -Dm755 makedpfw $out/bin/makedpfw
    install -Dm644 60-dediprog-em100pro.rules $out/lib/udev/rules.d/dediprog_em100.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.coreboot.org";
    description = "Open source tool for the EM100 SPI flash emulator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
    mainProgram = "em100";
  };
}
