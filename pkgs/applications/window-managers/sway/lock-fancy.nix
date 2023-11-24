{ lib
, stdenv
, fetchFromGitHub
, coreutils
, grim
, gawk
, jq
, swaylock
, imagemagick
, getopt
, fontconfig
, wmctrl
, makeWrapper
, bash
}:

let
  depsPath = lib.makeBinPath [
    coreutils
    grim
    gawk
    jq
    swaylock
    imagemagick
    getopt
    fontconfig
    wmctrl
  ];
  mainProgram = "swaylock-fancy";
in

stdenv.mkDerivation {
  pname = "swaylock-fancy";
  version = "unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "ff37ae3c6d0f100f81ff64fdb9d422c37de2f4f6";
    hash = "sha256-oS4YCbZOIrMP4QSM5eHWzTn18k3w2OnJ2k+64x/DnuM=";
  };

  postPatch = ''
    substituteInPlace ${mainProgram} \
      --replace "/usr/share" "$out/share"
  '';

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/${mainProgram} \
      --prefix PATH : "${depsPath}"
  '';

  meta = with lib; {
    description = "This is an swaylock bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = "https://github.com/Big-B/swaylock-fancy";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ frogamic ];
    inherit mainProgram;
  };
}
