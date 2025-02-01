{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "ianny";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "ianny";
    rev = "v${version}";
    hash = "sha256-F8Uc2BsQ5f7yaUXXDhLvyyYKUDAuvP9cCR2h3vblr0g=";
  };

  cargoHash = "sha256-b3B1LMa3gIL2xF9GL7jLXagesC9FEQHb8drocgx2MqY=";

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

  meta = with lib; {
    description = "Desktop utility that helps preventing repetitive strain injuries by keeping track of usage patterns and periodically informing the user to take breaks";
    homepage = "https://github.com/zefr0x/ianny";
    license = licenses.gpl3;
    mainProgram = "ianny";
    maintainers = with maintainers; [ max-amb ];
    platforms = platforms.linux;
  };
}
