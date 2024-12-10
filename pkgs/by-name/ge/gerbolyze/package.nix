{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  resvg,
}:

let
  version = "3.1.7";
  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbolyze";
    rev = "v${version}";
    hash = "sha256-0iTelSlUJUafclRowwsUAoO44nc/AXaOKXnZKfKOIaE=";
    fetchSubmodules = true;
  };

  svg-flatten = stdenv.mkDerivation rec {
    inherit version src;
    pname = "svg-flatten";

    sourceRoot = "${src.name}/svg-flatten";

    postPatch = ''
      substituteInPlace Makefile \
        --replace "$(INSTALL) $(BUILDDIR)/$(BINARY) $(PREFIX)/bin" \
        "$(INSTALL) $(BUILDDIR)/$(BINARY) $(PREFIX)/bin/svg-flatten" \
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      PREFIX=$out make install
      runHook postInstall
    '';

    meta = with lib; {
      description = "svg-flatten SVG downconverter";
      homepage = "https://github.com/jaseg/gerbolyze";
      license = with licenses; [ agpl3Plus ];
      maintainers = with maintainers; [ wulfsta ];
      mainProgram = "svg-flatten";
      platforms = platforms.linux;
    };
  };
in
python3Packages.buildPythonApplication rec {
  inherit version src;
  pname = "gerbolyze";

  format = "setuptools";

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = [
    python3Packages.beautifulsoup4
    python3Packages.click
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.python-slugify
    python3Packages.lxml
    python3Packages.gerbonara
    resvg
    svg-flatten
  ];

  preConfigure = ''
    # setup.py tries to execute a call to git in a subprocess, this avoids it.
    substituteInPlace setup.py \
      --replace "version = get_version()," \
                "version = '${version}'," \

    # setup.py tries to execute a call to git in a subprocess, this avoids it.
    substituteInPlace setup.py \
      --replace "long_description=format_readme_for_pypi()," \
                "long_description='\n'.join(Path('README.rst').read_text().splitlines()),"
  '';

  pythonImportsCheck = [ "gerbolyze" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    resvg
    svg-flatten
  ];

  meta = with lib; {
    description = "Directly render SVG overlays into Gerber and Excellon files";
    homepage = "https://github.com/jaseg/gerbolyze";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ wulfsta ];
    mainProgram = "gerbolyze";
    platforms = platforms.linux;
  };
}
