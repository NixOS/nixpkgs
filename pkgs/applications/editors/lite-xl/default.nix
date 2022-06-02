{ agg
, fetchFromGitHub
, Foundation
, freetype
, lib
, lua5_2
, meson
, ninja
, pcre2
, pkg-config
, reproc
, SDL2
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "lite-xl";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "lite-xl";
    repo = "lite-xl";
    rev = "v${version}";
    sha256 = "sha256-7ppO5ITijhJ37OL6xlQgu1SaQ/snXDH5xJOwuXZNUVA=";
  };

  patches = [
    # Fixes compatibility with Lua5.2, remove patch when a new release covers this
    ./0001-replace-unpack-with-table-unpack.patch
  ];

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    agg
    freetype
    lua5_2
    pcre2
    reproc
    SDL2
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  meta = with lib; {
    description = "A lightweight text editor written in Lua";
    homepage = "https://github.com/lite-xl/lite-xl";
    license = licenses.mit;
    maintainers = with maintainers; [ boppyt ];
    platforms = platforms.unix;
  };
}
