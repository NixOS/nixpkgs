{ lib
, stdenv
, fetchgit
}:

stdenv.mkDerivation rec {
  name = "ramfetch";
  version = "1.1.0a";

  src = fetchgit {
    url = "https://codeberg.org/jahway603/ramfetch.git";
    rev = version;
    hash = "sha256-sUreZ6zm+a1N77OZszjnpS4mmo5wL1dhNGVldJCGoag=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ramfetch $out/bin/ramfetch

    runHook postInstall
  '';

  meta = {
    description = "Tool which displays memory information";
    homepage = "https://codeberg.org/jahway603/ramfetch";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.markbeep ];
    mainProgram = "ramfetch";
  };
}
