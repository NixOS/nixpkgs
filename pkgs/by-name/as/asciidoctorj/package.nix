{
  lib,
  stdenv,
  fetchzip,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asciidoctorj";
  version = "3.0.1";

  src = fetchzip {
    url = "mirror://maven/org/asciidoctor/asciidoctorj/${finalAttrs.version}/asciidoctorj-${finalAttrs.version}-bin.zip";
    hash = "sha256-LzmROgzHnUZaK6uKxMUoM9/3q1wmBDlU0THfOOdUgcY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/asciidoctorj.bat
    cp -r . $out
    wrapProgram $out/bin/asciidoctorj \
      --prefix JAVA_HOME : ${jdk}
  '';

  meta = {
    description = "Official library for running Asciidoctor on the JVM";
    longDescription = ''
      AsciidoctorJ is the official library for running Asciidoctor on the JVM.
      Using AsciidoctorJ, you can convert AsciiDoc content or analyze the
      structure of a parsed AsciiDoc document from Java and other JVM
      languages.
    '';
    homepage = "https://asciidoctor.org/docs/asciidoctorj/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ moaxcp ];
    mainProgram = "asciidoctorj";
  };
})
