{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ncurses,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "rmw";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "theimpossibleastronaut";
    repo = "rmw";
    tag = "v${version}";
    hash = "sha256-rfJdJHSkusZj/PN74KgV5i36YC0YRZmIfRdvkUNoKEM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    ncurses
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  # The subproject "canfigger" has asan and ubsan enabled by default, disable it here
  mesonFlags = [
    "-Dcanfigger:b_sanitize=none"
  ];

  meta = with lib; {
    description = "Trashcan/ recycle bin utility for the command line";
    homepage = "https://github.com/theimpossibleastronaut/rmw";
    changelog = "https://github.com/theimpossibleastronaut/rmw/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "rmw";
  };
}
