{ lib, stdenvNoCC, fetchFromGitHub, mpv-unwrapped }:

stdenvNoCC.mkDerivation {
  name = "mpv-thumbfast";
  version = "unstable-2023-05-12";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "10e9f6133d4ea88e3e5d154969abfaee17173570";
    hash = "sha256-3fzkAR/itgheXQHTr30XPQR3NpYpIVeZfkcBxEoAnGg=";
  };

  postPatch = ''
    substituteInPlace thumbfast.lua \
      --replace 'mpv_path = "mpv"' 'mpv_path = "${lib.getBin mpv-unwrapped}/bin/mpv"'
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mpv/scripts
    cp -r thumbfast.lua $out/share/mpv/scripts/thumbfast.lua

    runHook postInstall
  '';

  passthru.scriptName = "thumbfast.lua";

  meta = {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = lib.licenses.unfree; # no explicit licensing information available at this time
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
