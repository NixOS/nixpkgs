{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gflags,
  pkgsBuildHost,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ng-log";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ng-log";
    repo = "ng-log";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NUMb65joJO+/NO/KlI7tQU2QnVMCxkJ5qqiaRuDjz6A=";
  };

  postPatch = ''
    substituteInPlace src/logging_unittest.cc \
      --replace-fail "/usr/bin/true" "${pkgsBuildHost.coreutils}/bin/true"
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DWITH_UNWIND=OFF"
  ];

  doCheck = true;

  meta = {
    description = "C++ library for application-level logging";
    homepage = "https://ng-log.github.io/ng-log";
    changelog = "https://github.com/ng-log/ng-log/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
