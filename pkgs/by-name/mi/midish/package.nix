{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "midish";
  version = "1.4.1";

  src = fetchurl {
    url = "https://midish.org/midish-${finalAttrs.version}.tar.gz";
    hash = "sha256-f5apBZSXzL17U98nuKSYlgG15eZIY+WQVXGsiW2VGqc=";
  };

  postPatch = ''
    substituteInPlace smfplay smfrec \
      --replace-fail "exec midish" "exec $out/bin/midish"
  '';

  buildInputs = [ alsa-lib ];

  runtimeDependencies = map lib.getLib [
    alsa-lib
  ];

  doCheck = true;

  meta = {
    description = "MIDI sequencer/filter for Unix-like operating systems";
    homepage = "https://midish.org/";
    license = lib.licenses.bsd1;
    maintainers = with lib.maintainers; [ iwanb ];
    platforms = lib.platforms.unix;
  };
})
