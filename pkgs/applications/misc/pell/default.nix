{ stdenv, fetchFromGitHub, scsh, sox, libnotify }:

stdenv.mkDerivation rec {
  pname = "pell";
  version = "0.0.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "ec14de0a9b666433954184167bf3b82cf21193f8";
    sha256 = "0r2gbb4l9rr5x99m62zicknsp1gf9fr124xpyd8ak9izr5hvskn9";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp pell $out/bin
    cp resources/notification.mp3 $out/share
    chmod +x $out/bin/pell
  '';

  postFixup = ''
    substituteInPlace $out/bin/pell --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/pell --replace "(play " "(${sox}/bin/play "
    substituteInPlace $out/bin/pell --replace "(notify-send " "(${libnotify}/bin/notify-send "
    substituteInPlace $out/bin/pell --replace "/usr/share/pell/notification.mp3" "$out/share/notification.mp3"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ebzzry/pell;
    description = "A simple host availability monitor";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };

  dontBuild = true;
}
