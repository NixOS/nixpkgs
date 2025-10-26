{
  lib,
  fetchFromGitHub,
  python3Packages,
  file,
  less,
  highlight,
  w3m,
  imagemagick,
  imagePreviewSupport ? true,
  sixelPreviewSupport ? true,
  neoVimSupport ? true,
  improvedEncodingDetection ? true,
  rightToLeftTextSupport ? false,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication {
  pname = "ranger";
  version = "1.9.3-unstable-2025-10-12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "6d5e0d8dc4cc5ddf53211e19f48c5b5e9ee47b18";
    hash = "sha256-gGJPa2k90BF28EB5cPnY0yn0YblJkhn105V2JQQv+xA=";
  };

  LC_ALL = "en_US.UTF-8";

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    astroid
    pylint
  ];
  propagatedBuildInputs = [
    less
    file
  ]
  ++ lib.optionals imagePreviewSupport [ python3Packages.pillow ]
  ++ lib.optionals sixelPreviewSupport [ imagemagick ]
  ++ lib.optionals neoVimSupport [ python3Packages.pynvim ]
  ++ lib.optionals improvedEncodingDetection [ python3Packages.chardet ]
  ++ lib.optionals rightToLeftTextSupport [ python3Packages.python-bidi ];

  preConfigure = ''
    ${lib.optionalString (highlight != null) ''
      sed -i -e 's|^\s*highlight\b|${highlight}/bin/highlight|' \
        ranger/data/scope.sh
    ''}

    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${lib.getBin less}/bin/less'"

    # give file previews out of the box
    substituteInPlace ranger/config/rc.conf \
      --replace /usr/share $out/share \
      --replace "#set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
  ''
  + lib.optionalString imagePreviewSupport ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true"
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.github.io/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      toonn
      lucasew
    ];
    mainProgram = "ranger";
  };
}
