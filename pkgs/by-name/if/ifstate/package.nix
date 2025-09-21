{
  lib,
  stdenv,
  yq,
  python3Packages,
  fetchFromGitea,
  iproute2,
  libbpf,
  nixosTests,
  withBpf ? false,
  withConfigValidation ? true,
  withShellColor ? false,
  withWireguard ? true,
}:

let
  version = "2.0.1";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "liske";
    repo = "ifstate";
    tag = version;
    hash = "sha256-QxjziDlkbTxAVd3qA8u4+JT8NWJxBMVAp7G5Zma9d10=";
  };
  docs = stdenv.mkDerivation {
    pname = "ifstate-docs";

    inherit version src;

    nativeBuildInputs = [ yq ];

    buildInputs =
      with python3Packages;
      (
        [
          mkdocs-material
          mkdocs-glightbox
          mkdocs-minify-plugin
        ]
        ++ mkdocs-material.optional-dependencies.imaging
      );

    postPatch = ''
      # git-revision-date requires a git repository
      # privacy and social plugin require internet
      yq -yi 'del(.plugins[] | select((type == "object" and (has("git-revision-date-localized") or has("social"))) or (type == "string" and . == "privacy")))' mkdocs.yaml
    '';

    buildPhase = ''
      runHook preBuild
      mkdir -p $out
      mkdocs build -d $out
      runHook postBuild
    '';
  };
  self = python3Packages.buildPythonApplication rec {
    pname = "ifstate";
    inherit version src;

    pyproject = true;

    postPatch = ''
      substituteInPlace libifstate/routing/__init__.py \
        --replace-fail '/usr/share/iproute2' '${iproute2}/share/iproute2'
    ''
    + lib.optionalString withBpf ''
      substituteInPlace libifstate/bpf/ctypes.py \
        --replace-fail 'libbpf.so.1' '${libbpf}/lib/libbpf.so.1'
    '';

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies =
      with python3Packages;
      [
        pyroute2
        pyyaml
        setproctitle
      ]
      ++ lib.optional withConfigValidation jsonschema
      ++ lib.optional withShellColor pygments
      ++ lib.optional withWireguard wgnlpy;

    pythonRemoveDeps = lib.optional (!withConfigValidation) "jsonschema";

    # has no unit tests
    doCheck = false;

    pythonImportsCheck = [
      "libifstate"
      "ifstate"
    ];

    passthru = {
      tests = nixosTests.ifstate;
      features = {
        inherit
          withBpf
          withConfigValidation
          withShellColor
          withWireguard
          ;
      };
      # needed for access in schema validaten in module
      jsonschema = "${self}/${python3Packages.python.sitePackages}/libifstate/schema/2/ifstate.conf.schema.json";
      inherit docs;
    };

    meta = {
      description = "Manage host interface settings in a declarative manner";
      homepage = "https://ifstate.net";
      changelog = "https://codeberg.org/liske/ifstate/src/tag/${src.tag}/CHANGELOG.md";
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ marcel ];
      mainProgram = "ifstatecli";
    };
  };
in
self
