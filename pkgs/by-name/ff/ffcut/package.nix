{
  lib,
  stdenv,
  fetchurl,
  ffmpeg,
  makeWrapper,
  perlPackages,
}:

let
  perlDeps = with perlPackages; [
    TimeDate
    FileWhich
  ];
  whichPatch = ./which.patch;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ffcut";
  version = "2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://youbroketheinternet.org/overlay/media-video/ffcut/files/ffcut";
    hash = "sha256-XouN1zHUMpkPRvzWOAz/4OjmKULWhN7XSRQlowP92bs=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  patchPhase = ''
    patch < ${whichPatch}
  '';

  unpackPhase = ''
    sourceRoot=.
    cp $src $sourceRoot/ffcut
  '';

  installPhase = ''
    install -D $sourceRoot/ffcut $out/bin/ffcut
  '';

  postFixup = ''
    wrapProgram $out/bin/ffcut \
      --set PERL5LIB "${perlPackages.makePerlPath perlDeps}" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    description = "Lossless video snipping CLI tool using ffmpeg or mp4box";
    mainProgram = "ffcut";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.dvn0 ];
  };
})
