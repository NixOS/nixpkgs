{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bakelite";
  version = "unstable-2023-03-30";

  src = fetchFromGitHub {
    owner = "richfelker";
    repo = pname;
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

  meta = with lib; {
    homepage = "https://github.com/richfelker/bakelite";
    description = "Incremental backup with strong cryptographic confidentality";
    mainProgram = "bakelite";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ mvs ];
    # no support for Darwin (yet: https://github.com/richfelker/bakelite/pull/5)
    platforms = platforms.linux;
  };
}
