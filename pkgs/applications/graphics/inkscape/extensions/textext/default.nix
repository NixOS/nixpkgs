{
  lib,
  writeScript,
  fetchFromGitHub,
  replaceVars,
  inkscape,
  pdflatex,
  lualatex,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  gtksourceview3,
}:

let
  launchScript = writeScript "launch.sh" ''
    cd $(dirname $0)
    ./__main__.py $*
  '';
in
python3.pkgs.buildPythonApplication rec {
  pname = "textext";
  version = "1.12.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "textext";
    repo = "textext";
    tag = version;
    sha256 = "sha256-Ka8NIvzhMZYPlc3q0U5Je7eXyBT61dJ3O++ETl+D7w0=";
  };

  patches = [
    # Make sure we can point directly to pdflatex in the extension,
    # instead of relying on the PATH (which might not have it)
    (replaceVars ./fix-paths.patch {
      inherit pdflatex lualatex;
    })

    # Since we are wrapping the extension, we need to change the interpreter
    # from Python to Bash.
    ./interpreter.patch
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    gtksourceview3
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
    # lxml, cssselect and numpy are required by inkex but is not inherited from inkscape when we use custom Python interpreter:
    python3.pkgs.lxml
    python3.pkgs.cssselect
    python3.pkgs.numpy
    python3.pkgs.tinycss2
  ];

  # strictDeps do not play nicely with introspection setup hooks.
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # TexText doesn’t have a 'bdist_wheel' target.
  dontUseSetuptoolsBuild = true;

  # TexText doesn’t have a 'test' target.
  doCheck = false;

  # Avoid wrapping two times by just using Python’s wrapping.
  dontWrapGApps = true;

  buildPhase = ''
    runHook preBuild

    mkdir dist

    # source/setup.py creates a config file in HOME (that we ignore)
    mkdir buildhome
    export HOME=$(pwd)/buildhome

    python setup.py \
      --inkscape-executable=${inkscape}/bin/inkscape \
      --pdflatex-executable=${pdflatex}/bin/pdflatex \
      --lualatex-executable=${lualatex}/bin/lualatex \
      --inkscape-extensions-path=dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/inkscape/extensions
    cp -r dist/textext $out/share/inkscape/extensions

    runHook postInstall
  '';

  preFixup = ''
    # Prepare for wrapping
    chmod +x "$out/share/inkscape/extensions/textext/__main__.py"
    sed -i '1i#!/usr/bin/env python3' "$out/share/inkscape/extensions/textext/__main__.py"

    # Include gobject-introspection typelibs in the wrapper.
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    # Wrap the project so it can find runtime dependencies.
    wrapPythonProgramsIn "$out/share/inkscape/extensions/textext" "$out $pythonPath"
    cp ${launchScript} $out/share/inkscape/extensions/textext/launch.sh
  '';

  meta = with lib; {
    description = "Re-editable LaTeX graphics for Inkscape";
    homepage = "https://textext.github.io/textext/";
    license = licenses.bsd3;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
}
