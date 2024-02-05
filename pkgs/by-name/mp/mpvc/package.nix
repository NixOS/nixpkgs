{ lib
, stdenvNoCC
, mpv
, socat
, fetchFromGitHub
, makeWrapper
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpvc";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "gmt4";
    repo = "mpvc";
    rev = finalAttrs.version;
    hash = "sha256-wPETEG0BtNBEj3ZyP70byLzIP+NMUKbnjQ+kdvrvK3s=";
  };

  postPatch = ''
    patchShebangs mpvc extras/mpvc-*
  '';

  outputs = [ "out" "doc" ];

  buildInputs = [
    mpv
    socat
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "DOCDIR=${placeholder "doc"}/share/doc/"
  ];

  preInstall = ''
    mkdir -p $out $doc/share/doc/
  '';

  postFixup = ''
    wrapProgram $out/bin/mpvc \
      --prefix PATH : "${lib.makeBinPath [ mpv socat ]}"
  '';

  meta = {
    description = "A mpc-like control interface for mpv";
    homepage = "https://gmt4.github.io/mpvc/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres neeasade ];
    platforms = lib.platforms.linux;
  };
})
