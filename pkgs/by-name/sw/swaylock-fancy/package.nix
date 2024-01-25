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
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "0b93740e1dfc39883c125c212a1adc16b01c14f1";
    hash = "sha256-ko4SeHGNBiPMvxFXhD+U2r0Mwc14C2IN5CaJYI0V8u8=";
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
