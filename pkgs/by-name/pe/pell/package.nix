{
  lib,
  stdenv,
  fetchFromGitHub,
  scsh,
  sox,
  libnotify,
}:

stdenv.mkDerivation {
  pname = "pell";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = "pell";
    rev = "3b8a9a59c4a8671705805edb7be7c35b1654971f";
    sha256 = "0k8m1lv2kyrs8fylxmbgxg3jn65g57frf2bndc82gkr5svwb554a";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp pell $out/bin
    cp resources/online.mp3 $out/share
    cp resources/offline.mp3 $out/share
    chmod +x $out/bin/pell
  '';

  postFixup = ''
    substituteInPlace $out/bin/pell --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/pell --replace "(play " "(${sox}/bin/play "
    substituteInPlace $out/bin/pell --replace "(notify-send " "(${libnotify}/bin/notify-send "
    substituteInPlace $out/bin/pell --replace "/usr/share/pell/online.mp3" "$out/share/online.mp3"
    substituteInPlace $out/bin/pell --replace "/usr/share/pell/offline.mp3" "$out/share/offline.mp3"
  '';

  meta = {
    homepage = "https://github.com/ebzzry/pell";
    description = "Simple host availability monitor";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ebzzry ];
    platforms = lib.platforms.unix;
    mainProgram = "pell";
  };

  dontBuild = true;
}
