{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  curl,
  gnugrep,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hblock";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "hectorm";
    repo = "hblock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cke3MppQm8p8B9+5IcvCplw6CtyRbgq46wHqli7U77I=";
  };

  buildInputs = [
    coreutils
    curl
    gnugrep
    gawk
  ];
  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "prefix=$(out)"
  ];
  postInstall = ''
    wrapProgram "$out/bin/hblock" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          gnugrep
          gawk
        ]
      }
  '';

  meta = {
    description = "Improve your security and privacy by blocking ads, tracking and malware domains";
    mainProgram = "hblock";
    homepage = "https://github.com/hectorm/hblock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alinnow ];
    platforms = lib.platforms.unix;
  };
})
