{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  alsa-lib,
  perl,
  pkg-config,
  SDL2,
  libXext,
  Cocoa,
}:

stdenv.mkDerivation rec {
  pname = "schismtracker";
  version = "20240809";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-J4al7XU+vvehDnp2fRrVesWyUN4i63g5btUkjarpXbk=";
  };

  # If we let it try to get the version from git, it will fail and fall back
  # on running `date`, which will output the epoch, which is considered invalid
  # in this assert: https://github.com/schismtracker/schismtracker/blob/a106b57e0f809b95d9e8bcf5a3975d27e0681b5a/schism/version.c#L112
  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'git log' 'echo ${version} #'
  '';

  configureFlags = [
    "--enable-dependency-tracking"
  ] ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-sdltest";

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs =
    [ SDL2 ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libXext
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];

  enableParallelBuilding = true;

  # Our Darwin SDL2 doesn't have a SDL2main to link against
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure.ac \
      --replace '-lSDL2main' '-lSDL2'
  '';

  meta = with lib; {
    description = "Music tracker application, free reimplementation of Impulse Tracker";
    homepage = "http://schismtracker.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
    mainProgram = "schismtracker";
  };
}
