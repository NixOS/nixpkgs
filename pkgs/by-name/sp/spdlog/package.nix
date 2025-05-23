{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fmt_11,
  catch2_3,
  staticBuild ? stdenv.hostPlatform.isStatic,

  # passthru
  bear,
  tiledb,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spdlog";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rOR9G2Y4Z4OBZtUHxID0s1aXN9ejodHrurlVCA0pIo=";
  };

  nativeBuildInputs = [ cmake ];
  # Required to build tests, even if they aren't executed
  buildInputs = [ catch2_3 ];
  propagatedBuildInputs = [ fmt_11 ];

  cmakeFlags = [
    (lib.cmakeBool "SPDLOG_BUILD_SHARED" (!staticBuild))
    (lib.cmakeBool "SPDLOG_BUILD_STATIC" staticBuild)
    (lib.cmakeBool "SPDLOG_BUILD_EXAMPLE" false)
    (lib.cmakeBool "SPDLOG_BUILD_BENCH" false)
    (lib.cmakeBool "SPDLOG_BUILD_TESTS" true)
    (lib.cmakeBool "SPDLOG_FMT_EXTERNAL" true)
  ];

  outputs = [
    "out"
    "doc"
    "dev"
  ];

  postInstall = ''
    mkdir -p $out/share/doc/spdlog
    cp -rv ../example $out/share/doc/spdlog

    substituteInPlace $dev/include/spdlog/tweakme.h \
      --replace-fail \
        '// #define SPDLOG_FMT_EXTERNAL' \
        '#define SPDLOG_FMT_EXTERNAL'
  '';

  doCheck = true;

  passthru = {
    tests = {
      inherit bear tiledb;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Very fast, header only, C++ logging library";
    homepage = "https://github.com/gabime/spdlog";
    changelog = "https://github.com/gabime/spdlog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obadz ];
    platforms = lib.platforms.all;
  };
})
