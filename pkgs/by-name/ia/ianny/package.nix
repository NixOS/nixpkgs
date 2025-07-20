{
  lib,
  fetchFromGitHub,
  rustPlatform,
  dbus,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "ianny";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "zefr0x";
    repo = "ianny";
    rev = "v${version}";
    hash = "sha256-XwwfBOx+5l5KjthL69nLpIVc7ilA4rKGBeRvE9BEQPU=";
  };

  cargoHash = "sha256-A5ZInR6gXvDPpa2azF1ZmVANzm3v1YAvxJjJ7h32J2A=";

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
