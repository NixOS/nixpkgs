{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "bakelite";
  version = "0.4.2-unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "richfelker";
    repo = "bakelite";
    rev = "65d69e88e0972d1493ebbd9bf9d1bfde36272636";
    hash = "sha256-OjBw9aYD2h7BWYgQzZp03hGCyQcRgmm2AjrcT/QrQAo=";
  };

  hardeningEnable = [ "pie" ];
  preBuild = ''
    # pipe2() is only exposed with _GNU_SOURCE
    # Upstream makefile explicitly uses -O3 to improve SHA-3 performance
    makeFlagsArray+=( CFLAGS="-D_GNU_SOURCE -g -O3" )
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bakelite $out/bin
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = {
    homepage = "https://github.com/richfelker/bakelite";
    description = "Incremental backup with strong cryptographic confidentality";
    mainProgram = "bakelite";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mvs ];
    # no support for Darwin (yet: https://github.com/richfelker/bakelite/pull/5)
    platforms = lib.platforms.linux;
  };
}
