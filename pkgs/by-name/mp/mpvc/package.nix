{ lib
, stdenvNoCC
, mpv
, socat
, fetchFromGitHub
, makeWrapper
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
    # This is not ArchLinux (TM), we don't need to store licensing files...
    rm -r $out/share/licenses
    rmdir $out/share/
    wrapProgram $out/bin/mpvc \
      --prefix PATH : "${lib.makeBinPath [ mpv socat ]}"
  '';

  meta = {
    description = "A mpc-like control interface for mpv";
    homepage = "https://gmt4.github.io/mpvc/";
    license = lib.licenses.mit;
    mainProgram = "mpvc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
