{ lib, stdenv, fetchFromGitHub, python3, mpv }:

stdenv.mkDerivation rec {
  pname = "ff2mpv";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sxUp/JlmnYW2sPDpIO2/q40cVJBVDveJvbQMT70yjP4=";
  };

  buildInputs = [ python3 mpv ];

  postPatch = ''
    patchShebangs .
    substituteInPlace ff2mpv.json \
      --replace '/home/william/scripts/ff2mpv' "$out/bin/ff2mpv.py"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/mozilla/native-messaging-hosts
    cp ff2mpv.py $out/bin
    cp ff2mpv.json $out/lib/mozilla/native-messaging-hosts
  '';

  meta = {
    description = "Native Messaging Host for ff2mpv firefox addon.";
    homepage = "https://github.com/woodruffw/ff2mpv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
  };
}
