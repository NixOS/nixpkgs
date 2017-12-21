{ stdenv, fetchFromGitHub, scsh, sox, libnotify }:

stdenv.mkDerivation rec {
  pname = "pell";
  version = "0.0.3";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "c25ddd257dd1d1481df5ccac0f99f6bee1ee1ebb";
    sha256 = "0fharadbf63mgpmafs8d4k9h83jj9naxldp240xnc5gkna32a07y";
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
