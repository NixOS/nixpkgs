{
  lib,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  socat,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpvc";
  version = "1.5-web";

  src = fetchFromGitHub {
    owner = "gmt4";
    repo = "mpvc";
    rev = finalAttrs.version;
    hash = "sha256-yNPTocqOJGCh/yLqa/3dpxhh5U2pmr6hQYu9l91D5Lg=";
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

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "DOCDIR=${placeholder "doc"}/share/doc/"
  ];

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  preInstall = ''
    mkdir -p $out $doc/share/doc/
  '';

  # This is not ArchLinux (TM), we don't need to store licensing files...
  postFixup = ''
    rm -r $out/share/
    wrapProgram $out/bin/mpvc \
      --prefix PATH : "${lib.makeBinPath [ mpv socat ]}"
  '';

  meta = {
    homepage = "https://gmt4.github.io/mpvc/";
    description = "A mpc-like control interface for mpv";
    license = lib.licenses.mit;
    mainProgram = "mpvc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
