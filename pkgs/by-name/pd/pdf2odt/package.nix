{
  bc,
  coreutils,
  fetchFromGitHub,
  file,
  findutils,
  gawk,
  ghostscript,
  gnused,
  imagemagick,
  lib,
  makeWrapper,
  stdenvNoCC,
  zip,
}:

stdenvNoCC.mkDerivation {
  pname = "pdf2odt";
  version = "20220827";

  src = fetchFromGitHub {
    owner = "gutschke";
    repo = "pdf2odt";
    rev = "a05fbdebcc39277d905d1ae66f585a19f467b406";
    hash = "sha256-995iF5Z1V4QEXeXUB8irG451TXpQBHZThJcEfHwfRtE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm0555 pdf2odt           -t $out/bin
    install -Dm0444 README.md LICENSE -t $out/share/doc/pdf2odt

    ln -rs $out/bin/pdf2odt $out/bin/pdf2ods

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/pdf2odt \
      --prefix PATH : ${
        lib.makeBinPath [
          bc
          coreutils
          file
          findutils
          gawk
          ghostscript
          gnused
          imagemagick
          zip
        ]
      }
  '';

  meta = {
    description = "PDF to ODT/ODS format converter";
    homepage = "https://github.com/gutschke/pdf2odt";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
