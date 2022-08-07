{ lib
, fetchFromGitHub

, cairo
, ffmpeg
, texlive

, python3
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
in python3.pkgs.buildPythonApplication rec {
  pname = "manim";
  format = "pyproject";
  version = "0.16.0";
  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner  = "ManimCommunity";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NQI+kJV0Mu2O/DlwwLYQw2jjJk/TmR7avBX9Fe7zmdk=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--no-cov-on-fail --cov=manim --cov-report xml --cov-report term" "" \
      --replace 'cloup = "^0.13.0"' 'cloup = "*"' \
      --replace 'mapbox-earcut = "^0.12.10"' 'mapbox-earcut = "*"' \
  '';

  buildInputs = [ cairo ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-default-group
    cloup
    colour
    grpcio
    grpcio-tools
    importlib-metadata
    isosurfaces
    jupyterlab
    manimpango
    mapbox-earcut
    moderngl
    moderngl-window
    networkx
    numpy
    pillow
    pycairo
    pydub
    pygments
    pysrt
    rich
    scipy
    screeninfo
    skia-pathops
    srt
    tqdm
    watchdog
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [
      ffmpeg
      (texlive.combine manim-tinytex)
    ])
  ];


  checkInputs = [
    python3.pkgs.pytest-xdist
    python3.pkgs.pytestCheckHook

    ffmpeg
    (texlive.combine manim-tinytex)
  ];

  # about 55 of ~600 tests failing mostly due to demand for display
  disabledTests = import ./failing_tests.nix;

  pythonImportsCheck = [ "manim" ];

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
