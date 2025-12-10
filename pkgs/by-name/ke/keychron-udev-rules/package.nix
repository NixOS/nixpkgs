{
  lib,
  stdenvNoCC,
  udevCheckHook,
  writeTextFile,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keychron-udev-rules";
  version = "23-10-2025";

  nativeBuildInputs = [ udevCheckHook ];

  src = writeTextFile {
    name = "69-keychron.rules";
    text = ''
      KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="3434", ENV{ID_INPUT_JOYSTICK}=="*?", ENV{ID_INPUT_JOYSTICK}=""
    '';
  };

  dontConfigure = true;
  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/lib/udev/rules.d/69-keychron.rules
    runHook postInstall
  '';

  meta = {
    description = "Keychron Keyboard Udev Rules, fixes issues with keyboard detection on Linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kruziikrel13 ];
  };
})
