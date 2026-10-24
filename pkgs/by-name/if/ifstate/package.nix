{
  lib,
  stdenv,
  yq,
  python3Packages,
  fetchFromCodeberg,
  rustPlatform,
  ethtool,
  iproute2,
  libbpf,
  installShellFiles,
  versionCheckHook,
  nixosTests,
  withBpf ? false,
  withConfigValidation ? true,
  withShellColor ? false,
}:

let
  version = "2.5.1";
  src = fetchFromCodeberg {
    owner = "routerkit";
    repo = "ifstate";
    tag = version;
    hash = "sha256-wRIFQQYSCsEmK7epFponyVEh9BrkjJWW8t34tDz7Ofg=";
  };
  mainProgram = "ifstatecli";

  libifstate-rs = python3Packages.buildPythonApplication (finalAttrs: {
    pname = "libifstate-rs";
    version = "0.4.2";

    src = fetchFromCodeberg {
      owner = "routerkit";
      repo = "libifstate-rs";
      tag = finalAttrs.version;
      hash = "sha256-PrF6Kxvd76DIyaoGg5kJyaAZN+3tgeyjOYT17xQ9wQY=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-s8gWx7+dV3NX0dmeohhpq4X5RbT3KV/LoML9oRu3Drc=";
    };

    pyproject = true;

    nativeBuildInputs = with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ];

    pythonImportsCheck = [ "libifstate_rs" ];
  });

  docs = stdenv.mkDerivation {
    pname = "ifstate-docs";

    inherit version src;

    nativeBuildInputs = [ yq ];

    buildInputs =
      with python3Packages;
      (
        [
          mkdocs-material
          mike
          mkdocs-glightbox
          mkdocs-macros-plugin
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

  self = python3Packages.buildPythonApplication (finalAttrs: {
    pname = "ifstate";
    inherit version src;

    pyproject = true;

    postPatch = ''
      substituteInPlace src/libifstate/paths.py \
        --replace-fail "/usr/sbin/ethtool" "${lib.getExe ethtool}" \
        --replace-fail '/usr/share/iproute2' '${iproute2}/share/iproute2'

      substituteInPlace src/libifstate/hook/wrapper.sh \
        --replace-fail ' ip ' ' ${lib.getExe' iproute2 "ip"} '

      # https://codeberg.org/routerkit/ifstate/pulls/241
      substituteInPlace src/libifstate/__init__.py \
        --replace-fail '2.5.0' '2.5.1'
    ''
    + lib.optionalString withBpf ''
      substituteInPlace src/libifstate/bpf/ctypes.py \
        --replace-fail 'libbpf.so.1' '${libbpf}/lib/libbpf.so.1'
    '';

    build-system = with python3Packages; [
      uv-build
    ];

    nativeBuildInputs = [
      installShellFiles
      python3Packages.shtab
    ];

    dependencies =
      with python3Packages;
      [
        pyroute2
        pyyaml
        setproctitle
        libifstate-rs
      ]
      ++ lib.optional withConfigValidation jsonschema
      ++ lib.optional withShellColor pygments;

    nativeCheckInputs = with python3Packages; [
      pytestCheckHook
      pytest-timeout
      pytest-cov-stub
      pytest-asyncio
    ];

    disabledTestPaths = [
      # e2e tests, need mount etc.
      # normal tests are in src
      "./tests"
    ];

    pythonRemoveDeps = lib.optional (!withConfigValidation) "jsonschema";

    pythonImportsCheck = [
      "libifstate"
      "ifstate"
    ];

    nativeInstallCheckInputs = [ versionCheckHook ];

    postInstall = ''
      installShellCompletion --cmd ${mainProgram} \
        --bash <(shtab --shell bash --prog ${mainProgram} ifstate.ifstate.get_parser) \
        --zsh <(shtab --shell zsh --prog ${mainProgram} ifstate.ifstate.get_parser)
    '';

    passthru = {
      tests = nixosTests.ifstate;
      features = {
        inherit
          withBpf
          withConfigValidation
          withShellColor
          ;
      };
      # needed for access in schema validation in module
      jsonschema = "${self}/${python3Packages.python.sitePackages}/libifstate/schema/2/ifstate.conf.schema.json";
      inherit docs;
    };

    meta = {
      description = "Manage host interface settings in a declarative manner";
      homepage = "https://ifstate.net";
      changelog = "https://codeberg.org/routerkit/ifstate/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
      platforms = lib.platforms.linux;
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ marcel ];
      inherit mainProgram;
    };
  });
in
self
