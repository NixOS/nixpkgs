{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  rapidjson,
  buildExamples ? false,
}:

stdenv.mkDerivation rec {
  pname = "discord-rpc";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "discordapp";
    repo = "discord-rpc";
    rev = "v${version}";
    sha256 = "04cxhqdv5r92lrpnhxf8702a8iackdf3sfk1050z7pijbijiql2a";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rapidjson
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=true"
    "-DBUILD_EXAMPLES=${lib.boolToString buildExamples}"
  ];

  patches = [
    # Adds unreleased PR https://github.com/discord/discord-rpc/pull/387
    (fetchpatch {
      name = "0001-Update-.clang-format.patch";
      url = "https://github.com/discord/discord-rpc/commit/dc26645316a1996a10995d9f5fae53ca1caddade.patch";
      hash = "sha256-geofgXwfbDsvsYCz92IVFrdvBDiGvMBiFd3GEbsdoHU=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 3.2.0)" \
      "cmake_minimum_required (VERSION 3.10.0)"
  '';

  meta = with lib; {
    description = "Official library to interface with the Discord client";
    homepage = "https://github.com/discordapp/discord-rpc";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
