{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  curl,
  wget,
  git,
  ripgrep,
  single-file-cli,
  postlight-parser,
  readability-extractor,
  chromium,
  versionCheckHook,
  nix-update-script,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      django = super.django_5;
      django-extensions = super.django-extensions.overridePythonAttrs {
        # Django 5.1 compat issues
        # https://github.com/django-extensions/django-extensions/issues/1885
        doCheck = false;
      };
      bx-django-utils = super.bx-django-utils.overridePythonAttrs {
        # Upstream has test cases for django 5.0 and 4.2 for these tests, but not 5.1, so they have to be disabled here.
        # Note that this isn't a direct dependency, but a dependency chain.
        # archivebox <- django-huey-monitor <- manage-django-project <- django-tools <- bx-django-utils
        disabledTests = [
          "test_index_page"
          "test_basic"
          "test_assert_html_response_snapshot"
        ];
      };
      manage-django-project = super.manage-django-project.overridePythonAttrs (old: {
        # Same reason and dependency chain as above, no Django 5.1 test snapshots so this test fails.
        disabledTests = (old.disabledTests or [ ]) ++ [
          "test_help"
        ];
      });
      django-taggit = super.django-taggit.overridePythonAttrs rec {
        version = "6.1.0";
        src = fetchFromGitHub {
          owner = "jazzband";
          repo = "django-taggit";
          rev = "refs/tags/${version}";
          hash = "sha256-QLJhO517VONuf+8rrpZ6SXMP/WWymOIKfd4eyviwCsU=";
        };
      };
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.8.6rc3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "ArchiveBox";
    # TODO: Go back to tag when available
    # rev = "refs/tags/v${version}";
    rev = "b74b0d23b46834eb4310fd4efa71db2c02900314";
    hash = "sha256-6B/or/8VM4F65m+OhKuFWPCulTBAkz2Et8nwzxTLr5M=";
  };

  build-system = with python.pkgs; [
    pdm-backend
    hatchling
    uv
  ];

  env = {
    UV_NO_CACHE = "1";
    UV_PYTHON_DOWNLOADS = "never";
    UV_PYTHON = python.interpreter;
    UV_NO_BUILD_ISOLATION = "1";
  };

  buildPhase = ''
    runHook preBuild

    uv build --offline --wheel --all

    runHook postBuild
  '';

  dontCheckRuntimeDeps = true;

  # Dependencies are ordered the same way that upstream does in their pyproject.toml
  # So that it is easier to tell if dependencies are added/removed
  dependencies =
    with python.pkgs;
    [
      # Django Libraries
      django
      channels
      daphne
      # Tests do not pass in the Nix build environment, so disable them.
      # It still works properly
      (django-ninja.overridePythonAttrs { doCheck = false; })
      django-extensions
      django-huey
      django-huey-monitor
      django-signal-webhooks
      django-admin-data-views
      django-object-actions
      django-charid-field
      django-taggit

      # State Management
      pluggy
      python-statemachine

      # CLI/Logging
      click
      rich
      rich-click
      ipython

      # Host OS/System
      abx-pkg
      supervisor
      psutil
      platformdirs
      py-machineid
      atomicwrites
      python-crontab
      croniter

      # Base Types
      pydantic
      pydantic-settings
      python-benedict
      ulid-py
      typeid-python
      base32-crockford
      blake3

      # Static Typing
      mypy-extensions
      django-stubs

      # API Clients
      requests
      sonic-client
      pocket

      # Parsers
      feedparser
      dateparser
      tzdata
      w3lib
    ]
    ++ lib.flatten (lib.attrValues python.pkgs.python-benedict.optional-dependencies);

  optional-dependencies = {
    ldap = with python.pkgs; [
      python-ldap
      django-auth-ldap
    ];
    debug = with python.pkgs; [
      django-debug-toolbar
      djdt-flamegraph
      ipdb
      requests-tracker
      django-autotyping
    ];
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  makeWrapperArgs = [
    "--set USE_NODE True" # used through dependencies, not needed explicitly
    "--set READABILITY_BINARY ${lib.getExe readability-extractor}"
    "--set MERCURY_BINARY ${lib.getExe postlight-parser}"
    "--set CURL_BINARY ${lib.getExe curl}"
    "--set RIPGREP_BINARY ${lib.getExe ripgrep}"
    "--set WGET_BINARY ${lib.getExe wget}"
    "--set GIT_BINARY ${lib.getExe git}"
    "--set YOUTUBEDL_BINARY ${lib.getExe python.pkgs.yt-dlp}"
    "--set SINGLEFILE_BINARY ${lib.getExe single-file-cli}"
    (
      if (lib.meta.availableOn stdenv.hostPlatform chromium) then
        "--set CHROME_BINARY ${lib.getExe chromium}"
      else
        "--set-default USE_CHROME False"
    )
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      siraben
      viraptor
      pyrox0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "archivebox";
  };
}
