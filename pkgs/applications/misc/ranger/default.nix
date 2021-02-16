{ lib, fetchFromGitHub, python3Packages, file, less, highlight
, imagePreviewSupport ? true, w3m }:

python3Packages.buildPythonApplication rec {
  pname = "ranger";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "ranger";
    repo = "ranger";
    rev = "v${version}";
    sha256= "1rygfryczanvqxn43lmlkgs04sbqznbvbb9hlbm3h5qgdcl0xlw8";
  };

  LC_ALL = "en_US.UTF-8";

  checkInputs = with python3Packages; [ pytestCheckHook ];
  propagatedBuildInputs = [ file ]
    ++ lib.optionals (imagePreviewSupport) [ python3Packages.pillow ];

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
    homepage = "http://ranger.github.io/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ toonn magnetophon ];
  };
}
