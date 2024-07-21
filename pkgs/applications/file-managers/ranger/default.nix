{ lib, fetchFromGitHub, python3Packages, file, less, highlight, w3m, ranger, imagemagick, testers
, imagePreviewSupport ? true
, sixelPreviewSupport ? true
, neoVimSupport ? true
, improvedEncodingDetection ? true
, rightToLeftTextSupport ? false
}:

python3Packages.buildPythonApplication rec {
  pname = "ranger";
  version = "1.9.3-unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "38bb8901004b75a407ffee4b9e176bc0a436cb15";
    hash = "sha256-NpsrABk95xHNvhlRjKFh326IW83mYj1cmK3aE9JQSRo=";
  };

  LC_ALL = "en_US.UTF-8";

  nativeCheckInputs = with python3Packages; [ pytestCheckHook astroid pylint ];
  propagatedBuildInputs = [
    less
    file
  ] ++ lib.optionals imagePreviewSupport [ python3Packages.pillow ]
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
  '' + lib.optionalString imagePreviewSupport ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true"
  '';

  meta =  with lib; {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.github.io/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ toonn magnetophon ];
    mainProgram = "ranger";
  };
}
