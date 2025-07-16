{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cctz";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "v${version}";
    sha256 = "sha256-YCE0DXuOT5tCOfLlemMH7I2F8c7HEK1NEUJvtfqnCg8=";
  };

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework CoreFoundation";

  makeFlags = [ "PREFIX=$(out)" ];

  installTargets =
    [ "install_hdrs" ]
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "install_shared_lib"
    ++ lib.optional stdenv.hostPlatform.isStatic "install_lib";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libcctz.so $out/lib/libcctz.so
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/google/cctz";
    description = "C++ library for translating between absolute and civil times";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
