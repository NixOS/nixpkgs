{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  fmt,
  catch2,
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

  patches = [
    # https://github.com/gabime/spdlog/pull/3451
    (fetchpatch {
      name = "catch2-3.9.0-compat.patch";
      url = "https://github.com/gabime/spdlog/commit/3edc8036dbf3c7cdf0e460a913ae294c87ae90dc.patch";
      hash = "sha256-0XtNaAvDGpSTtQZjxmLbHOoY4OMZDJfLDzBh7gNQh2c=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  # Required to build tests, even if they aren't executed
  buildInputs = [ catch2 ];
  propagatedBuildInputs = [ fmt ];

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
