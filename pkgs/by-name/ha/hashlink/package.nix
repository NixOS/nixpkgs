{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  libGL,
  libGLU,
  libpng,
  libjpeg_turbo,
  libuv,
  libvorbis,
  mbedtls_2,
  openal,
  pcre,
  SDL2,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "hashlink";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "sha256-nVr+fDdna8EEHvIiXsccWFRTYzXfb4GG1zrfL+O6zLA=";
  };

  # incompatible pointer type error: const char ** -> const void **
  postPatch = ''
    substituteInPlace libs/sqlite/sqlite.c \
     --replace-warn \
       "sqlite3_prepare16_v2(db->db, sql, -1, &r->r, &tl)" \
       "sqlite3_prepare16_v2(db->db, sql, -1, &r->r, (const void**)&tl)"
  '';

  buildInputs = [
    libGL
    libGLU
    libjpeg_turbo
    libpng
    libuv
    libvorbis
    mbedtls_2
    openal
    pcre
    SDL2
    sqlite
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  # append default installPhase with library install for haxe
  postInstall =
    let
      haxelibPath = "$out/lib/haxe/hashlink/${lib.replaceStrings [ "." ] [ "," ] version}";
    in
    ''
      mkdir -p "${haxelibPath}"
      echo -n "${version}" > "${haxelibPath}/../.current"
      cp -r ../other/haxelib/* "${haxelibPath}"
    '';

  meta = with lib; {
    description = "Virtual machine for Haxe";
    mainProgram = "hl";
    homepage = "https://hashlink.haxe.org/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [
      iblech
      locallycompact
      logo
    ];
  };
}
