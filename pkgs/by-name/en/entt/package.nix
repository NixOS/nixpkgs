{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "entt";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IPAM7fr/tvSOMKWUbXbloNAnlp5t7J0ynSsTMZ2jKYs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/skypjack/entt";
    description = "Header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with lib.maintainers; [ twey ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
})
