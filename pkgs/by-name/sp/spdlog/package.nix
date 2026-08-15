{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  fmt,
  catch2_3,
  staticBuild ? stdenv.hostPlatform.isStatic,

  # passthru
  bear,
  tiledb,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spdlog";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
  };

  patches = [
    (fetchpatch {
      # Remove when updating past 1.17.0. Fixes `pkgsMusl.spdlog` build.
      url = "https://github.com/gabime/spdlog/commit/0f7562a0f9273cfc71fddc6ae52ebff7a490fa04.patch";
      name = "tests-timezone-Provide-DST-rules-when-setting-TZ-on-POSIX-systems";
      hash = "sha256-jsw3AgTXeRdU2ncuzAkYp6SPrBKntz2I3NLOjAPkW78=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  # Required to build tests, even if they aren't executed
  buildInputs = [ catch2_3 ];
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
