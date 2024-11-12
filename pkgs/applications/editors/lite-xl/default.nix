{ fetchFromGitHub
, Foundation
, freetype
, lib
, lua5_4
, meson
, ninja
, pcre2
, pkg-config
, SDL2
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lite-xl";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "lite-xl";
    repo = "lite-xl";
    rev = "v${version}";
    hash = "sha256-awXcmYAvQUdFUr2vFlnBt8WTLrACREfB7J8HoSyVPTs=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    freetype
    lua5_4
    pcre2
    SDL2
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Foundation
  ];

  mesonFlags = [
    "-Duse_system_lua=true"
  ];

  meta = with lib; {
    description = "Lightweight text editor written in Lua";
    homepage = "https://github.com/lite-xl/lite-xl";
    license = licenses.mit;
    maintainers = with maintainers; [ sefidel ];
    platforms = platforms.unix;
    mainProgram = "lite-xl";
  };
}
