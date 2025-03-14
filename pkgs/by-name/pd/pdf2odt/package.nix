{
  lib,
  resholve,
  fetchFromGitHub,
  bc,
  coreutils,
  file,
  gawk,
  ghostscript,
  gnused,
  imagemagick,
  zip,
  runtimeShell,
  findutils,
}:

resholve.mkDerivation {
  pname = "pdf2odt";
  version = "20220827";

  src = fetchFromGitHub {
    owner = "gutschke";
    repo = "pdf2odt";
    rev = "a05fbdebcc39277d905d1ae66f585a19f467b406";
    hash = "sha256-995iF5Z1V4QEXeXUB8irG451TXpQBHZThJcEfHwfRtE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0555 pdf2odt           -t $out/bin
    install -Dm0444 README.md LICENSE -t $out/share/doc/pdf2odt

    ln -rs $out/bin/pdf2odt $out/bin/pdf2ods

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/pdf2odt" ];
    interpreter = runtimeShell;
    inputs = [
      bc
      coreutils
      file
      findutils
      gawk
      ghostscript
      gnused
      imagemagick
      zip
    ];
    execer = [
      # zip can exec; confirmed 2 invocations in pdf2odt don't
      "cannot:${zip}/bin/zip"
    ];
  };

  meta = with lib; {
    description = "PDF to ODT/ODS format converter";
    homepage = "https://github.com/gutschke/pdf2odt";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
