{
  coreutils,
  fetchFromGitHub,
  gzip,
  jq,
  lib,
  makeWrapper,
  qrencode,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "quill-qr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = "quill-qr";
    rev = "v${version}";
    hash = "sha256-JoOpx1yXuLyfVRn7+emv8xYqUk5sheG50Nv1qpnBus0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a quill-qr.sh $out/bin/quill-qr.sh
    patchShebangs $out/bin

    wrapProgram $out/bin/quill-qr.sh --prefix PATH : "${
      lib.makeBinPath [
        qrencode
        coreutils
        jq
        gzip
      ]
    }"
  '';

  meta = {
    description = "Print QR codes for use with https://p5deo-6aaaa-aaaab-aaaxq-cai.raw.ic0.app";
    mainProgram = "quill-qr.sh";
    homepage = "https://github.com/colonelpanic8/quill-qr";
    maintainers = with lib.maintainers; [ imalison ];
    platforms = with lib.platforms; linux;
    license = lib.licenses.unfree;
  };
}
