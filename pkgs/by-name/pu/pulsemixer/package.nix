{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pulsemixer";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "GeorgeFilipkin";
    repo = "pulsemixer";
    rev = finalAttrs.version;
    hash = "sha256-5IrU++iJMAz38I6riLdxiXPz8BQyC48a1e6WX3/qT8k=";
  };

  inherit libpulseaudio;

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install pulsemixer $out/bin/
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pulsemixer" \
      --replace-fail "libpulse.so.0" "$libpulseaudio/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  meta = {
    description = "Cli and curses mixer for pulseaudio";
    homepage = "https://github.com/GeorgeFilipkin/pulsemixer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.woffs ];
    platforms = lib.platforms.all;
    mainProgram = "pulsemixer";
  };
})
