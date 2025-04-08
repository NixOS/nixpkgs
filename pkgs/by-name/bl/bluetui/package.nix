{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluetui";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${version}";
    hash = "sha256-JgxzpFpz/fyFZwyxTtAkG9XB5qkxj46lUnZ3mM44dHk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1+hMo5vzgqm9Dpx9ZqRpHfQTRZV2RmqslQNub1+LFnk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
}
