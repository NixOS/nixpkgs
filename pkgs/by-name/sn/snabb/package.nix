{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snabb";
  version = "2026.11";

  src = fetchFromGitHub {
    owner = "snabbco";
    repo = "snabb";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CIPEl/b8tLW82Yd6KHBTVZYnjUsdy9lugwYOfqqhzE4=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp src/snabb $out/bin
  '';

  meta = {
    homepage = "https://github.com/SnabbCo/snabbswitch";
    description = "Simple and fast packet networking toolkit";
    longDescription = ''
      Snabb Switch is a LuaJIT-based toolkit for writing high-speed
      packet networking code (such as routing, switching, firewalling,
      and so on). It includes both a scripting interface for creating
      new applications and also some built-in applications that are
      ready to run.
      It is especially intended for ISPs and other network operators.
    '';
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lukego ];
    mainProgram = "snabb";
  };
})
