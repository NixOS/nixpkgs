{ lib
, fetchFromGitHub
, dolphin-emu
, stdenv
}:

dolphin-emu.overrideAttrs (oldAttrs: rec {
  pname = "dolphin-emu-primehack";
  version = "1.0.7a";

  src = fetchFromGitHub {
    owner = "shiiion";
    repo = "dolphin";
    rev = version;
    sha256 = "sha256-vuTSXQHnR4HxAGGiPg5tUzfiXROU3+E9kyjH+T6zVmc=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mv $out/bin/dolphin-emu $out/bin/dolphin-emu-primehack
    mv $out/bin/dolphin-emu-nogui $out/bin/dolphin-emu-primehack-nogui
    mv $out/share/applications/dolphin-emu.desktop $out/share/applications/dolphin-emu-primehack.desktop
    mv $out/share/icons/hicolor/256x256/apps/dolphin-emu.png $out/share/icons/hicolor/256x256/apps/dolphin-emu-primehack.png
    substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop --replace 'dolphin-emu' 'dolphin-emu-primehack'
    substituteInPlace $out/share/applications/dolphin-emu-primehack.desktop --replace 'Dolphin Emulator' 'PrimeHack'
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/shiiion/dolphin";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten Madouura ];
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
})
