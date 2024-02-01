{ lib, stdenv, fetchFromGitHub, python3, ruby, mpv }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ff2mpv";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = "ff2mpv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sxUp/JlmnYW2sPDpIO2/q40cVJBVDveJvbQMT70yjP4=";
  };

  buildInputs = [ python3 ruby mpv ];

  postPatch = ''
    patchShebangs .
    substituteInPlace ff2mpv.json \
      --replace '/home/william/scripts/ff2mpv' "$out/bin/ff2mpv.py"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/mozilla/native-messaging-hosts
    cp ff2mpv.py ff2mpv $out/bin
    cp ff2mpv.json $out/lib/mozilla/native-messaging-hosts

    runHook postInstall
  '';

  meta = {
    description = "Native Messaging Host for ff2mpv firefox addon.";
    homepage = "https://github.com/woodruffw/ff2mpv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "ff2mpv.py";
  };
})
