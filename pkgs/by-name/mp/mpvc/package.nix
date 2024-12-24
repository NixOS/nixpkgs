{
  lib,
  fetchFromGitHub,
  makeWrapper,
  socat,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpvc";
  version = "1.4-unstable-2024-07-09";

  src = fetchFromGitHub {
    owner = "gmt4";
    repo = "mpvc";
    rev = "966156dacd026cde220951d41c4ac5915cd6ad64";
    hash = "sha256-/M3xOb0trUaxJGXmV2+sOCbrHGyP4jpyo+S/oBoDkO0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ socat ];

  outputs = [
    "out"
    "doc"
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  installFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  postInstall = ''
    wrapProgram $out/bin/mpvc --prefix PATH : "${lib.getBin socat}/"
  '';

  # This is not Archlinux :)
  postFixup = ''
    rm -r $out/share/licenses
    rmdir $out/share || true
  '';

  meta = {
    homepage = "https://github.com/gmt4/mpvc";
    description = "Mpc-like control interface for mpv";
    license = lib.licenses.mit;
    mainProgram = "mpvc";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
