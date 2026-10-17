{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  gnugrep,
  libnotify,
  scrot,
  which,
  xclip,
}:

let
  deps = lib.makeBinPath [
    curl
    jq
    gnugrep
    libnotify
    scrot
    which
    xclip
  ];
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.0.0";
  pname = "imgur-screenshot";

  src = fetchFromGitHub {
    owner = "jomo";
    repo = "imgur-screenshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-szRd6UCyQ11ZnFYPeujJg8FgVyAyvmsA4nnJqLLbcDo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 imgur-screenshot $out/bin/imgur-screenshot
    wrapProgram $out/bin/imgur-screenshot --prefix PATH ':' ${deps}
  '';

  meta = {
    description = "Tool for easy screencapping and uploading to imgur";
    homepage = "https://github.com/jomo/imgur-screenshot/";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "imgur-screenshot";
  };
})
