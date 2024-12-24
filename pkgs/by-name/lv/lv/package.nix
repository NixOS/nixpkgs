{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  unstableGitUpdater,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "lv";
  version = "4.51-unstable-2020-08-03";

  src = fetchFromGitHub {
    owner = "ttdoda";
    repo = "lv";
    rev = "1fb214d4136334a1f6cd932b99f85c74609e1f23";
    hash = "sha256-mUFiWzTTM6nAKQgXA0sYIUm1MwN7HBHD8LWBgzu3ZUk=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  preAutoreconf = "cd src";
  postAutoreconf = "cd ..";

  configurePhase = ''
    mkdir -p build
    cd build
    ../src/configure
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "Powerful multi-lingual file viewer / grep";
    homepage = "https://github.com/ttdoda/lv";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ kayhide ];
  };
}
