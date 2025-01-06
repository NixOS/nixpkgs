{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epoll-shim";
  version = "0.0.20240608";

  src = fetchFromGitHub {
    owner = "jiixyj";
    repo = "epoll-shim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PIVzVjXOECGv41KtAUmGzUiQ+4lVIyzGEOzVQQ1Pc54=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PKGCONFIGDIR=${placeholder "out"}/lib/pkgconfig"
    "-DBUILD_TESTING=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

  # https://github.com/jiixyj/epoll-shim/issues/41
  # https://github.com/jiixyj/epoll-shim/pull/34
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Small epoll implementation using kqueue";
    homepage = "https://github.com/jiixyj/epoll-shim";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin ++ lib.platforms.freebsd ++ lib.platforms.netbsd ++ lib.platforms.openbsd;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
