{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  jre,
  docbook-xsl-ns,
  docbook_xml_dtd_42,
  imagemagick,
  libxslt,
  stripJavaArchivesHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gogui";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Remi-Coulom";
    repo = "gogui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pJGZpSFdOvMkeetdX3+wB+8sk3LO6znJ0dUNvjOmiB8=";
  };

  nativeBuildInputs = [
    ant
    jdk
    docbook-xsl-ns
    imagemagick
    libxslt
    stripJavaArchivesHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    substituteInPlace doc/manual/xml/book.xml \
      --replace-fail http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd \
      ${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd
    substituteInPlace doc/manual/xml/manpages.xml \
      --replace-fail http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd \
      ${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd

    # generate required gui images from svg
    # see https://github.com/Remi-Coulom/gogui/issues/36
    sizes=( 16x16 24x24 32x32 48x48 64x64 )
    for i in src/net/sf/gogui/images/*.svg; do
      for j in ''${sizes[@]}; do
        convert $i -resize $j src/net/sf/gogui/images/$(basename $i .svg)-''${j}.png
      done
    done

    for i in src/net/sf/gogui/images/gogui-{black,white,setup}.svg; do
      convert $i -resize 8x8 src/net/sf/gogui/images/$(basename $i .svg)-8x8.png
    done

    ant -Ddocbook-xsl.dir=${docbook-xsl-ns}/xml/xsl/docbook

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # copy documentation
    mkdir -p $out/share/doc
    mv -vi doc $out/share/doc/gogui

    # make man pages available
    mkdir -p $out/share/man/
    ln -s $out/share/doc/gogui/manual/man $out/share/man/man1

    # copy programs
    mv -vi bin lib $out/

    # wrap programs
    for x in $out/bin/*; do
        wrapProgram $x \
            --prefix PATH : ${jre}/bin \
            --set GOGUI_JAVA_HOME ${jre}
    done

    runHook postInstall
  '';

  meta = {
    description = "Graphical user interface to programs that play the board game Go and support the Go Text Protocol such as GNU Go";
    homepage = "https://github.com/Remi-Coulom/gogui";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gogui";
    maintainers = with lib.maintainers; [
      cleverca22
      omnipotententity
    ];
    platforms = lib.platforms.unix;
  };
})
