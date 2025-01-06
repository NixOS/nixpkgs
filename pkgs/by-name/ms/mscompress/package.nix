{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mscompress";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "stapelberg";
    repo = "mscompress";
    rev = finalAttrs.version;
    hash = "sha256-Urq8CzVfO9tdEUrEya+bUzoNjZQ2TO7OB+h2MTAGwEI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 -t $out/share/doc/mscompress ChangeLog README TODO
  '';

  meta = {
    description = ''Microsoft "compress.exe/expand.exe" compatible (de)compressor'';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
  };
})
