{ agg
, fetchFromGitHub
, fetchpatch
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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "lite-xl";
    repo = "lite-xl";
    rev = "v${version}";
    sha256 = "sha256-+RbmT6H/5Ldhv3qOClxMjCSGMudbkGtkjo2SpGqExao=";
  };

  patches = [
    # Fixes compatibility with Lua5.2, remove patch when PR merged
    # https://github.com/lite-xl/lite-xl/pull/435
    (fetchpatch {
      name = "0001-replace-unpack-with-table.unpack.patch";
      url = "https://github.com/lite-xl/lite-xl/commit/30ccde896d1ffe37cbd8990e9b8aaef275e18935.patch";
      sha256 = "sha256-IAe3jIyD3OtZtu1V7MtPR4QzFKvU/aV/nLQ4U9nHyIQ=";
    })
    # Lets meson fallback to the system reproc if available.
    # remove patch when 2.0.2 is proposed.
    (fetchpatch {
      name = "0002-use-dependency-fallbacks-use-system-reproc-if-available.patch";
      url = "https://github.com/lite-xl/lite-xl/commit/973acb787aacb0164b2f4ae6fe335d250ba80a7b.patch";
      sha256 = "sha256-GmgATsRlj1FePmw3+AoWEMZIo2eujHYewKQCx583qbU=";
    })
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
