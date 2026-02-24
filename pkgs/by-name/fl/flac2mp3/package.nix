{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  perl,
  perlPackages,
  flac,
  lame,
}:

stdenv.mkDerivation rec {
  pname = "flac2mp3";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "robinbowes";
    repo = "flac2mp3";
    tag = version;
    hash = "sha256-mzZAlCMQYcKEkeJ0464zE1+F5KwA9IjvAbx6aZVCaxI=";
  };

  patches = [
    (fetchpatch {
      # Fix https://github.com/robinbowes/flac2mp3/issues/58
      url = "https://github.com/lfence/flac2mp3/commit/cf89d4abe09595299fcced61a42ed423a0186c20.patch";
      hash = "sha256-XKNF1uxzHL0xGeMeVHro8r4EImf1VSTTt7rH4T4zodc=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r lib/* $out/lib/
    install -Dm755 flac2mp3.pl $out/bin/flac2mp3

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/flac2mp3 \
      --prefix PERL5LIB : "$out/lib" \
      --prefix PATH : "${
        lib.makeBinPath [
          flac
          lame
        ]
      }"
  '';

  meta = with lib; {
    mainProgram = "flac2mp3";
    description = "Tool to convert audio files from flac to mp3 format including the copying of tags";
    homepage = "https://github.com/robinbowes/flac2mp3";
    changelog = "https://github.com/robinbowes/flac2mp3/releases/tag/${src.tag}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ lilahummel ];
  };
}
