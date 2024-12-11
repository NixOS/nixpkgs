{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation {
  pname = "parson";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "kgabis";
    repo = "parson";
    rev = "ba29f4eda9ea7703a9f6a9cf2b0532a2605723c3"; # upstream doesn't use tags
    hash = "sha256-IEmCa0nauUzG+zcLpr++ySD7i21zVJh/35r9RaQkok0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Lightweight JSON library written in C";
    homepage = "https://github.com/kgabis/parson";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
