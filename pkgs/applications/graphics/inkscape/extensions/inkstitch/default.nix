{
  lib,
  python3,
  fetchFromGitHub,
  fetchFromGitLab,
  gettext,
}:
let
  # on update check compatibility to nixpkgs inkex
  version = "3.2.2";

  # remove and use nixpkgs version is recent enough
  inkex' = python3.pkgs.inkex.overrideAttrs (old: rec {
    # this is no special commit, just the most recent as of writing
    version = "3150a5b3b06f7e4c2104d9e8eb6dc448982bb2b0";
    src = fetchFromGitLab {
      owner = "inkscape";
      repo = "extensions";
      rev = "${version}";
      hash = "sha256-FYBZ66ERC3nVYCaAmFPqKnBxDOKAoQwT14C0fKLn10c=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'scour = "^0.37"' 'scour = ">=0.37"'
    '';
  });

  dependencies =
    with python3.pkgs;
    [
      pyembroidery
      # inkex upstream release & nixpkgs is too old
      # use nixpkgs inkex once up to date
      inkex'
      wxpython
      networkx
      platformdirs
      shapely
      lxml
      appdirs
      numpy
      jinja2
      requests
      colormath2
      flask
      fonttools
      trimesh
      scipy
      diskcache
      flask-cors
    ]
    # Inkstitch uses the builtin tomllib instead when Python >=3.11
    ++ lib.optional (pythonOlder "3.11") tomli;
  pyEnv = python3.withPackages (_: dependencies);
in
python3.pkgs.buildPythonApplication {
  pname = "inkstitch";
  inherit version;
  pyproject = false; # Uses a Makefile (yikes)

  src = fetchFromGitHub {
    owner = "inkstitch";
    repo = "inkstitch";
    tag = "v${version}";
    hash = "sha256-6EVfjmTXEYgZta01amK8E6t5h2JBPfGGNnqfBG8LQfo=";
  };

  nativeBuildInputs = [
    gettext
    pyEnv
  ];

  inherit dependencies;

  env = {
    # to overwrite version string
    GITHUB_REF = version;
    BUILD = "nixpkgs";
  };
  makeFlags = [ "manual" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/inkscape/extensions
    cp -a . $out/share/inkscape/extensions/inkstitch

    runHook postInstall
  '';

  patches = [
    ./0001-force-frozen-true.patch
    ./0002-plugin-invocation-use-python-script-as-entrypoint.patch
    ./0003-lazy-load-module-to-access-global_settings.patch
    ./0004-enable-force-insertion-of-python-path.patch
  ];

  doCheck = false;

  postPatch = ''
    # Add shebang with python dependencies
    substituteInPlace lib/inx/utils.py --replace-fail ' interpreter="python"' ""
    sed -i -e '1i#!${pyEnv.interpreter}' inkstitch.py
    chmod a+x inkstitch.py
  '';

  postInstall = ''
    export SITE_PACKAGES=$(find "${pyEnv}" -type d -name 'site-packages')
    wrapProgram $out/share/inkscape/extensions/inkstitch/inkstitch.py \
      --set PYTHON_INKEX_PATH "$SITE_PACKAGES"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = {
    description = "Inkscape extension for machine embroidery design";
    homepage = "https://inkstitch.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [
      tropf
      pluiedev
    ];
  };
}
