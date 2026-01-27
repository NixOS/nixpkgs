{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "entt";
  version = "3.16.0";

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
    hash = "sha256-i4K7NigYPYAOsVLhtjQJFmm9LoWiTg39F8SIBRuv4Vg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DENTT_INSTALL=ON" ];

  meta = {
    homepage = "https://github.com/skypjack/entt";
    description = "Header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with lib.maintainers; [ twey ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
}
