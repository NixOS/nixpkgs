{
  coreutils,
  fetchFromGitHub,
  gzip,
  jq,
  lib,
  makeWrapper,
  ncurses,
  qrencode,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quill-qr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "quill-qr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JoOpx1yXuLyfVRn7+emv8xYqUk5sheG50Nv1qpnBus0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a quill-qr.sh $out/bin/quill-qr
    patchShebangs $out/bin

    wrapProgram $out/bin/quill-qr --prefix PATH : "${
      lib.makeBinPath [
        qrencode
        coreutils
        jq
        gzip
        ncurses
      ]
    }"
  '';

  meta = {
    description = "Print QR codes for use with https://p5deo-6aaaa-aaaab-aaaxq-cai.raw.ic0.app";
    mainProgram = "quill-qr";
    homepage = "https://github.com/IvanMalison/quill-qr";
    maintainers = [ lib.maintainers.imalison ];
    platforms = lib.platforms.linux;
  };
})
