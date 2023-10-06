{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, openjdk8
, ant
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "brmodelo";
  version = "3.31";

  src = fetchFromGitHub {
    owner = "chcandido";
    repo = pname;
    rev = version;
    sha256 = "09qrhqhv264x8phnf3pnb0cwq75l7xdsj9xkwlvhry81nxz0d5v0";
  };

  nativeBuildInputs = [ ant makeWrapper copyDesktopItems ];

  buildInputs = [ openjdk8 ];

  patches = [
    # Fixes for building with Ant.
    # https://github.com/chcandido/brModelo/pull/22
    (fetchpatch {
      name = "fix-self-closing-element-not-allowed.patch";
      url = "https://github.com/yuuyins/brModelo/commit/0d712b74fd5d29d67be07480ed196da28a77893b.patch";
      sha256 = "sha256-yy03arE6xetotzyvpToi9o9crg3KnMRn1J70jDUvSXE=";
    })
    (fetchpatch {
      name = "fix-tag-closing.patch";
      url = "https://github.com/yuuyins/brModelo/commit/e8530ff75f024cf6effe0408ed69985405e9709c.patch";
      sha256 = "sha256-MNuh/ORbaAkB5qDSlA/nPrXN+tqzz4oOglVyEtSangI=";
    })
    (fetchpatch {
      name = "fix-bad-use-greater-than.patch";
      url = "https://github.com/yuuyins/brModelo/commit/498a6ef8129daff5a472b318f93c8f7f2897fc7f.patch";
      sha256 = "sha256-MmAwYUmx38DGRsiSxCWCObtpqxk0ykUQiDSC76bCpFc=";
    })
    (fetchpatch {
      name = "fix-param-errors.patch";
      url = "https://github.com/yuuyins/brModelo/commit/8a508aaba0bcffe13a3f95cff495230beea36bc4.patch";
      sha256 = "sha256-qME9gZChSMzu1vs9HaosD+snb+jlOrQLY97meNoA8oU=";
    })

    # Add SVG icons.
    # https://github.com/chcandido/brModelo/pull/23
    (fetchpatch {
      name = "add-brmodelo-logo-icons-svg.patch";
      url = "https://github.com/yuuyins/brModelo/commit/f260b82b664fad3325bbf3ebd7a15488d496946b.patch";
      sha256 = "sha256-UhgcWxsHkNFS1GgaRnmlZohjDR8JwHof2cIb3SBetYs=";
    })
  ];

  buildPhase = ''
    ant
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "brmodelo";
      desktopName = "brModelo";
      genericName = "Entity-relationship diagramming tool";
      exec = "brmodelo";
      icon = "brmodelo";
      comment = meta.description;
      categories = [ "Development" "Education" "Database" "2DGraphics" "ComputerScience" "DataVisualization" "Engineering" "Java" ];
    })
  ];

  installPhase = ''
    install -d $out/bin $out/share/doc/${pname} $out/share/java

    cp -rv ./dist/javadoc $out/share/doc/${pname}/

    install -Dm755 ./dist/brModelo.jar -t $out/share/java/
    # NOTE: The standard Java GUI toolkit has a
    # hard-coded list of "non-reparenting" window managers,
    # which cause issues while running brModelo
    # in WMs that are not in that list (e.g. XMonad).
    # Solution/Workaround: set the environment variable
    # _JAVA_AWT_WM_NONREPARENTING=1.
    makeWrapper ${openjdk8}/bin/java $out/bin/brmodelo \
       --prefix _JAVA_AWT_WM_NONREPARENTING : 1 \
       --prefix _JAVA_OPTIONS : "-Dawt.useSystemAAFontSettings=on" \
       --add-flags "-jar $out/share/java/brModelo.jar"

    runHook postInstall
  '';

  postInstall = ''
    for size in 16 24 32 48 64 128 256; do
      install -Dm644 ./src/imagens/icone_"$size"x"$size".svg \
        $out/share/icons/hicolor/"$size"x"$size"/apps/brmodelo.svg
    done
  '';

  meta = with lib; {
    description = "Entity-relationship diagram tool for making conceptual and logical database models";
    homepage = "https://github.com/chcandido/brModelo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yuu ];
  };
}
