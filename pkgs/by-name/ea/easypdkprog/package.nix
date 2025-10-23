{
  stdenv,
  lib,
  fetchFromGitHub,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "easypdkprog";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "free-pdk";
    repo = "easy-pdk-programmer-software";
    rev = version;
    sha256 = "0hc3gdmn6l01z63hzzwdhbdyy288gh5v219bsfm8fb1498vpnd6f";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm755 -t $out/bin easypdkprog
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 -t $out/etc/udev/rules.d Linux_udevrules/70-stm32vcp.rules
  '';

  meta = with lib; {
    description = "Read, write and execute programs on PADAUK microcontroller";
    mainProgram = "easypdkprog";
    homepage = "https://github.com/free-pdk/easy-pdk-programmer-software";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ david-sawatzke ];
    platforms = platforms.unix;
  };
}
