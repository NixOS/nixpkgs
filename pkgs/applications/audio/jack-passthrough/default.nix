{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libjack2
, meson
, ninja
, fmt_9
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jack-passthrough";
  version = "2021-9-25";

  # https://github.com/guysherman/jack-passthrough
  src = fetchFromGitHub {
    owner = "guysherman";
    repo = finalAttrs.pname;
    rev = "aad03b7c5ccc4a4dcb8fa38c49aa64cb9d628660";
    hash = "sha256-9IsNaLW5dYAqiwe+vX0+D3oIKFP2TIfy1q1YaqmS6wE=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ fmt_9 libjack2 ];

  meta = with lib; {
    description = "A simple app to help with JACK apps that behave strangely.";
    longDescription = ''
      Creates a JACK passthrough client with an arbitrary name and number of
      ports. Common uses include tricking stubborn applications into creating
      more ports than they normally would or to prevent them from
      auto-connecting to certain things.
    '';
    # license unknown: https://github.com/guysherman/jack-passthrough/issues/2
    license = licenses.unfree;
    maintainers = [ maintainers.PowerUser64 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "jack-passthru";
  };
})
