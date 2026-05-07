{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ianny";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "ianny";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CPtVk8sG3LcJBgmPc/kYZZXW0Lt2OPJGzkLKac+/1ZI=";
  };

  cargoHash = "sha256-R8NEsGKaoYMssl1OkHXGV+1/oVPkZsbfdgLfRHp+ApA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus.dev ];

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail '/usr/share/locale' $out/share/locale
  '';

  preFixup = ''
    mkdir -p $out/etc/xdg/autostart
    mkdir -p $out/usr/share/local
    cp io.github.zefr0x.ianny.desktop $out/etc/xdg/autostart/
  '';

  meta = {
    description = "Desktop utility that helps preventing repetitive strain injuries by keeping track of usage patterns and periodically informing the user to take breaks";
    homepage = "https://github.com/zefr0x/ianny";
    license = lib.licenses.gpl3;
    mainProgram = "ianny";
    maintainers = with lib.maintainers; [ max-amb ];
    platforms = lib.platforms.linux;
  };
})
