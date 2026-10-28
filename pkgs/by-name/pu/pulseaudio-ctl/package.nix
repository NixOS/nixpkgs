{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bc,
  dbus,
  gawk,
  gnused,
  libnotify,
  pulseaudio,
}:

let
  path = lib.makeBinPath [
    bc
    dbus
    gawk
    gnused
    libnotify
    pulseaudio
  ];
  pname = "pulseaudio-ctl";
  version = "1.70";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "pulseaudio-ctl";
    rev = "v${version}";
    sha256 = "sha256-ZB1jrr31PF7+vNB+Xo5CATJmYbuDAPwewpDxCVnAowY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr $out

    substituteInPlace common/${pname}.in \
      --replace '$0' ${pname}
  '';

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${path}
  '';

  meta = {
    description = "Control pulseaudio volume from the shell or mapped to keyboard shortcuts. No need for alsa-utils";
    mainProgram = "pulseaudio-ctl";
    homepage = "https://bbs.archlinux.org/viewtopic.php?id=124513";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
}
