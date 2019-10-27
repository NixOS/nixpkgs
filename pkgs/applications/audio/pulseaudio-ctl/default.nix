{ stdenv, fetchFromGitHub, makeWrapper
, bc, dbus, gawk, gnused, libnotify, pulseaudio }:

let
  path = stdenv.lib.makeBinPath [ bc dbus gawk gnused libnotify pulseaudio ];
  pname = "pulseaudio-ctl";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.67";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mf5r7x6aiqmx9mz7gpckrqvvzxnr5gs2q1k4m42rjk6ldkpdb46";
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
