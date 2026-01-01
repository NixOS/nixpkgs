{
  lib,
  fetchFromGitHub,
  python3Packages,
  file,
<<<<<<< HEAD
  coreutils,
  bashNonInteractive,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  less,
  highlight,
  w3m,
  imagemagick,
  imagePreviewSupport ? true,
  sixelPreviewSupport ? true,
  neoVimSupport ? true,
  improvedEncodingDetection ? true,
  rightToLeftTextSupport ? false,
<<<<<<< HEAD
  nix-update-script,
=======
  unstableGitUpdater,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

python3Packages.buildPythonApplication {
  pname = "ranger";
<<<<<<< HEAD
  version = "1.9.4-unstable-2025-11-14";
  pyproject = true;
=======
  version = "1.9.3-unstable-2025-11-14";
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "08913377c968d39f11fa2d546aa8d53a99bb5e98";
    hash = "sha256-vn1rAOFB2vq04Y/WAE44iH/b/zamAmvq8putUKwNqR8=";
  };

<<<<<<< HEAD
  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    [ ]
    ++ lib.optionals imagePreviewSupport [ python3Packages.pillow ]
    ++ lib.optionals neoVimSupport [ python3Packages.pynvim ]
    ++ lib.optionals improvedEncodingDetection [ python3Packages.chardet ]
    ++ lib.optionals rightToLeftTextSupport [ python3Packages.python-bidi ];
=======
  LC_ALL = "en_US.UTF-8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    astroid
    pylint
  ];
<<<<<<< HEAD

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
=======
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

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    substituteInPlace ranger/__init__.py \
      --replace "DEFAULT_PAGER = 'less'" "DEFAULT_PAGER = '${lib.getBin less}/bin/less'"

    # give file previews out of the box
    substituteInPlace ranger/config/rc.conf \
      --replace /usr/share $out/share \
      --replace "#set preview_script ~/.config/ranger/scope.sh" "set preview_script $out/share/doc/ranger/config/scope.sh"
  ''
<<<<<<< HEAD
  + lib.optionalString (highlight != null) ''
    sed -i -e 's|^\s*highlight\b|${highlight}/bin/highlight|' \
      ranger/data/scope.sh
  ''
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  + lib.optionalString imagePreviewSupport ''
    substituteInPlace ranger/ext/img_display.py \
      --replace /usr/lib/w3m ${w3m}/libexec/w3m

    # give image previews out of the box when building with w3m
    substituteInPlace ranger/config/rc.conf \
      --replace "set preview_images false" "set preview_images true"
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.fm/";
=======
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "File manager with minimalistic curses interface";
    homepage = "https://ranger.github.io/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      toonn
      lucasew
    ];
    mainProgram = "ranger";
  };
}
