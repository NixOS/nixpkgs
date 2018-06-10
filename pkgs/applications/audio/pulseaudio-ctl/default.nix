{ stdenv, fetchFromGitHub, makeWrapper
, bc, dbus, gawk, gnused, libnotify, pulseaudioLight }:

let
  path = stdenv.lib.makeBinPath [ bc dbus gawk gnused libnotify pulseaudioLight ];
  pname = "pulseaudio-ctl";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.66";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = pname;
    rev = "v${version}";
    sha256 = "19a24w7y19551ar41q848w7r1imqkl9cpff4dpb7yry7qp1yjg0y";
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

  meta = with stdenv.lib; {
    description = "Control pulseaudio volume from the shell or mapped to keyboard shortcuts. No need for alsa-utils.";
    homepage = https://bbs.archlinux.org/viewtopic.php?id=124513;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
