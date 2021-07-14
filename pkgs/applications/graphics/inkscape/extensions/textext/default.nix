{ lib
, fetchFromGitHub
, substituteAll
, inkscape
, pdflatex
, lualatex
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, gtksourceview3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "textext";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "textext";
    repo = "textext";
    rev = version;
    sha256 = "1gd8x0mb7hkfywi5brqig3d06hd5dsgsgqk8lsv7hcsbalk5hkga";
  };

  patches = [
    # Make sure we can point directly to pdflatex in the extension,
    # instead of relying on the PATH (which might not have it)
    (substituteAll {
      src = ./fix-paths.patch;
      inherit pdflatex lualatex;
    })

    # Since we are wrapping the extension, we need to change the interpreter
    # from Python to Bash.
    ./interpreter.patch
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    gtksourceview3
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
    # TODO: Required by inkex but is not inherited from inkscape when we use custom Python interpreter.
    python3.pkgs.lxml
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
  '';

  meta = with lib; {
    description = "Re-editable LaTeX graphics for Inkscape";
    homepage = "https://textext.github.io/textext/";
    license = licenses.bsd3;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
}
