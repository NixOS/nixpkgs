{
  stdenv,
  lib,
  fetchFromGitHub,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easypdkprog";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "free-pdk";
    repo = "easy-pdk-programmer-software";
    rev = finalAttrs.version;
    hash = "sha256-zjR7N0okLIeq0ysFsQt8CAnv24KN/w+H+QFQY2t7g0E=";
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

  meta = {
    description = "Read, write and execute programs on PADAUK microcontroller";
    mainProgram = "easypdkprog";
    homepage = "https://github.com/free-pdk/easy-pdk-programmer-software";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ david-sawatzke ];
    platforms = lib.platforms.unix;
  };
})
