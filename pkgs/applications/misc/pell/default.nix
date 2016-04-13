{ stdenv, fetchFromGitHub, scsh, sox, libnotify }:

stdenv.mkDerivation rec {
  pname = "pell";
  version = "0.0.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "3f95341eb9439c7a6be1f3c6366c0552ab8208f0";
    sha256 = "183aj3ys080g2kahl8x8rkhzlsb6h5ls9xm1v2kasfbn1pi5i6nn";
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
    description = "A simple periodic host monitor using ping";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };

  dontBuild = true;
}
