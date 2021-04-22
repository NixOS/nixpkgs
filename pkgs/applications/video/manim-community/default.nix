{ lib
, fetchPypi

, buildPythonApplication
, pythonOlder

, cairo
, ffmpeg_4
, sox
, xdg-utils
, texlive

, python
, colour
, numpy
, pillow
, scipy
, tqdm
, pydub
, pygments
, rich
, pycairo
, manimpango
, networkx
, setuptools
, importlib-metadata
, grpcio
, grpcio-tools
, watchdog
, jupyterlab
, moderngl
, moderngl-window
, mapbox-earcut
}:

let
  # According to ManimCommunity documentation manim uses tex-packages packaged
  # in a custom distribution called "manim-latex",
  #
  #   https://community.chocolatey.org/packages/manim-latex#files
  #
  # which includes another cutom distribution called tinytex, for which the
  # package list can be found at
  #
  #   https://github.com/yihui/tinytex/blob/master/tools/pkgs-custom.txt
  #
  # these two combined add up to:
  manim-tinytex = {
    inherit (texlive)

    # tinytex
    scheme-infraonly amsfonts amsmath atbegshi atveryend auxhook babel bibtex
    bigintcalc bitset booktabs cm dehyph dvipdfmx dvips ec epstopdf-pkg etex
    etexcmds etoolbox euenc everyshi fancyvrb filehook firstaid float fontspec
    framed geometry gettitlestring glyphlist graphics graphics-cfg graphics-def
    grffile helvetic hycolor hyperref hyph-utf8 iftex inconsolata infwarerr
    intcalc knuth-lib kvdefinekeys kvoptions kvsetkeys l3backend l3kernel
    l3packages latex latex-amsmath-dev latex-bin latex-fonts latex-tools-dev
    latexconfig latexmk letltxmacro lm lm-math ltxcmds lua-alt-getopt luahbtex
    lualatex-math lualibs luaotfload luatex mdwtools metafont mfware natbib
    pdfescape pdftex pdftexcmds plain psnfss refcount rerunfilecheck stringenc
    tex tex-ini-files times tipa tools unicode-data unicode-math uniquecounter
    url xcolor xetex xetexconfig xkeyval xunicode zapfding

    # manim-latex
    standalone everysel preview doublestroke ms setspace rsfs relsize ragged2e
    fundus-calligra microtype wasysym physics dvisvgm jknapltx wasy cm-super
    babel-english gnu-freefont mathastext cbfonts-fd;
  };
in
buildPythonApplication rec {
  pname = "manim-community";
  version = "0.5.0";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "manim";
    inherit version;
    sha256 = "e4284648cbb5d463c6dbced1d4e60fa9b68c14f4bb3b10c8eab0f8f49ca5da88";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=[0-9.]\+,<[0-9.]\+//' -i setup.py
  '';

  propagatedBuildInputs = [
    python
    colour
    numpy
    pillow
    scipy
    tqdm
    pydub
    pygments
    rich
    pycairo
    manimpango
    networkx
    setuptools
    importlib-metadata
    grpcio
    grpcio-tools
    watchdog
    jupyterlab
    moderngl
    moderngl-window
    mapbox-earcut

    cairo
    sox
    ffmpeg_4
    xdg-utils

    (texlive.combine manim-tinytex)
  ];

  # no tests included with PyPi package. TODO: use github repo as source and
  # include tests
  doCheck = false;

  # provide a new / unique name for everything in bin, in case one wants to have both
  # manim-packages installed
  postInstall = ''
    mv $out/bin/manim $out/bin/manim-com
    mv $out/bin/manimce $out/bin/manimce-com
  '';

  meta = with lib; {
    description = "Animation engine for explanatory math videos - Community version";
    longDescription = ''
      Manim is an animation engine for explanatory math videos. It's used to
      create precise animations programmatically, as seen in the videos of
      3Blue1Brown on YouTube. This is the community maintained version of
      manim.
    '';
    homepage = "https://github.com/ManimCommunity/manim";
    license = licenses.mit;
    maintainers = with maintainers; [ friedelino ];
  };
}
