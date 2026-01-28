{
  lib,
  fetchFromGitHub,
  python3Packages,
  file,
  coreutils,
  bashNonInteractive,
  less,
  highlight,
  w3m,
  imagemagick,
  imagePreviewSupport ? true,
  sixelPreviewSupport ? true,
  neoVimSupport ? true,
  improvedEncodingDetection ? true,
  rightToLeftTextSupport ? false,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "ranger";
  version = "1.9.4-unstable-2026-01-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "46c4fde3831dcf00ed85ee4e089df28601932229";
    hash = "sha256-9/9TSLXcFC+ItCCCQGaYoCjOyPH9Zx3JCKJJXf0SINI=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    [ ]
    ++ lib.optionals imagePreviewSupport [ python3Packages.pillow ]
    ++ lib.optionals neoVimSupport [ python3Packages.pynvim ]
    ++ lib.optionals improvedEncodingDetection [ python3Packages.chardet ]
    ++ lib.optionals rightToLeftTextSupport [ python3Packages.python-bidi ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    astroid
    pylint
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath (
      [
        file
        coreutils
        bashNonInteractive
      ]
      ++ lib.optionals sixelPreviewSupport [ imagemagick ]
    ))
  ];

  postPatch = ''
    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${lib.getBin less}/bin/less'"

    # give file previews out of the box
    substituteInPlace ranger/config/rc.conf \
      --replace /usr/share $out/share \
      --replace "#set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
  ''
  + lib.optionalString (highlight != null) ''
    sed -i -e 's|^\s*highlight\b|${highlight}/bin/highlight|' \
      ranger/data/scope.sh
  ''
  + lib.optionalString imagePreviewSupport ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.fm/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      toonn
      lucasew
    ];
    mainProgram = "ranger";
  };
}
