{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, tokyocabinet, ncurses
, cairo ? null, pango ? null
, enableCairo ? stdenv.hostPlatform.isLinux
}:

assert enableCairo -> cairo != null && pango != null;

stdenv.mkDerivation rec {
  pname = "duc";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "duc";
    rev = version;
    sha256 = "sha256-ZLNsyp82UnsveEfDKzH8WfRh/Y/PQlXq8Ma+jIZl9Gk=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ tokyocabinet ncurses ] ++
    lib.optionals enableCairo [ cairo pango ];

  configureFlags =
    lib.optionals (!enableCairo) [ "--disable-x11" "--disable-cairo" ];

  meta = with lib; {
    homepage = "http://duc.zevv.nl/";
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2Only;

    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "duc";
  };
}
