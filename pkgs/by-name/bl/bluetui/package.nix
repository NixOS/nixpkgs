{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluetui";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${version}";
    hash = "sha256-qryBx0Lezg98FzfAFZR6+j7byJTW7hMbGmKIQMkciec=";
  };

  cargoHash = "sha256-CijMGqsfyoUV8TSy1dWUR//PCySgkxKGuhUMHp4Tn48=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  postInstall = ''
    install -Dm444 bluetui.desktop -t $out/share/applications
  '';

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
}
