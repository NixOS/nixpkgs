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
    owner = "IvanMalison";
    repo = "quill-qr";
    rev = "v${version}";
    sha256 = "1kdsq6csmxfvs2wy31bc9r92l5pkmzlzkyqrangvrf4pbk3sk0r6";
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

  meta = with lib; {
    description = "Print QR codes for use with https://p5deo-6aaaa-aaaab-aaaxq-cai.raw.ic0.app";
    mainProgram = "quill-qr.sh";
    homepage = "https://github.com/IvanMalison/quill-qr";
    maintainers = with maintainers; [ imalison ];
    platforms = with platforms; linux;
  };
}
