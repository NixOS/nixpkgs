{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "flashbench-unstable";
  version = "2020-01-23";

  src = fetchFromGitHub {
    owner = "bradfa";
    repo = "flashbench";
    rev = "d783b1bd2443812c6deadc31b081f043e43e4c1a";
    hash = "sha256-hWPpxNjxqmmHu7jWdb8N3lUvDIKXlI7+jKIbr+4MshA=";
  };

  installPhase = ''
    runHook preInstall

    install -d -m755 $out/bin $out/share/doc/flashbench
    install -v -m755 flashbench $out/bin
    install -v -m755 erase $out/bin/flashbench-erase
    install -v -m644 README $out/share/doc/flashbench

    runHook postInstall
  '';

  meta = {
    description = "Testing tool for flash based memory devices";
    homepage = "https://github.com/bradfa/flashbench";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
