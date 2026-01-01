{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
<<<<<<< HEAD
  canfigger,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ncurses,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "rmw";
<<<<<<< HEAD
  version = "0.9.4";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "theimpossibleastronaut";
    repo = "rmw";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/bE9fFjn3mPfUbtsB6bXfQAxUtbtuZiT4pevi5RCQA4=";
=======
    hash = "sha256-rfJdJHSkusZj/PN74KgV5i36YC0YRZmIfRdvkUNoKEM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
<<<<<<< HEAD
    canfigger
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ncurses
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

<<<<<<< HEAD
  meta = {
    description = "Trashcan/ recycle bin utility for the command line";
    homepage = "https://github.com/theimpossibleastronaut/rmw";
    changelog = "https://github.com/theimpossibleastronaut/rmw/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rmw";
  };
}
