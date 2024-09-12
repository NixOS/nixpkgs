{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage rec {
  pname = "rucola";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Linus-Mussmaecher";
    repo = "rucola";
    rev = "v${version}";
    hash = "sha256-6ybFz+DSv50QvG6XUvyvrrkOmsc5LPdXeALiaL8rSnQ=";
  };

  cargoHash = "sha256-KP28bDTNv4NmkQyE0g3GGsgzJt6MPx+ZRH6YJbiv0H4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Terminal-based markdown note manager";
    homepage = "https://github.com/Linus-Mussmaecher/rucola";
    changelog = "https://github.com/Linus-Mussmaecher/rucola/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "rucola";
  };
}
