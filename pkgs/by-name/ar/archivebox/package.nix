{
  lib,
  stdenv,
  python3,
  fetchPypi,
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
  # Extra Python packages to add to the archivebox environment (e.g., abx-compatible plugins)
  extraPackages ? (_ps: [ ]),
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      # ArchiveBox 0.9.x requires Django >= 6.0
      django = super.django_6;
      # Daphne's startup-timeout tests can leave a live server for multiprocessing shutdown to join.
      daphne = super.daphne.overridePythonAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ ./daphne-startup-cleanup.patch ];
      });
      # abx-dl excludes psutil 7.2.2; align every ArchiveBox dependency path.
      psutil = super.psutil.overridePythonAttrs (oldAttrs: rec {
        version = "7.2.1";
        src = fetchPypi {
          pname = oldAttrs.pname;
          inherit version;
          hash = "sha256-91g67FkEhbQ8pgHdnOoNzWW9e7IdMO9N2/Tqa17RvdM=";
        };
        meta = oldAttrs.meta // {
          changelog = "https://github.com/giampaolo/psutil/blob/release-${version}/HISTORY.rst";
        };
      });
    };
  };
  pythonDependencies =
    with python.pkgs;
    [
      ### Django libraries
      setuptools
      django
      daphne
      django-ninja
      django-extensions
      django-signal-webhooks
      django-admin-data-views
      django-object-actions
      django-taggit
      bleach

      ### State management
      python-statemachine

      ### CLI / Logging
      click
      rich
      rich-click
      ipython

      ### Host OS / System
      supervisor
      platformdirs
      py-machineid
      atomicwrites
      browser-cookie3
      psycopg
      toml

      ### Base types
      pydantic
      pydantic-settings
      python-benedict
      base32-crockford
      uuid7

      ### Static typing
      django-stubs

      ### API clients
      requests
      sonic-client

      ### Parsers
      dateparser
      croniter
      tzdata
      w3lib

      ### Binary / Package management
      abxbus
      abxpkg
      abx-plugins
      abx-dl
    ]
    ++ lib.flatten (lib.attrValues python.pkgs.python-benedict.optional-dependencies)
    ++ lib.flatten (lib.attrValues python.pkgs.abx-plugins.optional-dependencies)
    ++ (extraPackages python.pkgs);
in

python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "archivebox";
  version = "0.9.73";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "ArchiveBox";
    rev = "6f5d2f60a01a7ca1171d3b3ddac3310d13c47fab";
    hash = "sha256-gzg7CTUT0tD0LwRYT1MIFPPGR5Z70mwpSYenW8QMbGk=";
  };

  build-system = with python.pkgs; [
    pdm-backend
  ];

  # Dependencies are ordered the same way that upstream does in their pyproject.toml
  # so that it is easier to tell if dependencies are added/removed on upgrade
  dependencies = pythonDependencies;

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
    # ArchiveBox resolves supervisord through PATH before starting its workers.
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ python.pkgs.supervisor ]}"
    # PEP 723 hooks launched through abxpkg run in an isolated interpreter.
    # Expose ArchiveBox's declared Python dependencies to those hook processes.
    "--prefix"
    "PYTHONPATH"
    ":"
    "${python.pkgs.makePythonPath pythonDependencies}:${placeholder "out"}/${python.sitePackages}"
    "--set"
    "CURL_BINARY"
    "${lib.getExe curl}"
    "--set"
    "RIPGREP_BINARY"
    "${lib.getExe ripgrep}"
    "--set"
    "WGET_BINARY"
    "${lib.getExe wget}"
    "--set"
    "GIT_BINARY"
    "${lib.getExe git}"
    "--set"
    "YOUTUBEDL_BINARY"
    "${lib.getExe python.pkgs.yt-dlp}"
    "--set"
    "SINGLEFILE_BINARY"
    "${lib.getExe single-file-cli}"
    "--set"
    "READABILITY_BINARY"
    "${lib.getExe readability-extractor}"
    "--set"
    "MERCURY_BINARY"
    "${lib.getExe postlight-parser}"
  ]
  ++ (
    if (lib.meta.availableOn stdenv.hostPlatform chromium) then
      [
        "--set"
        "CHROME_BINARY"
        "${lib.getExe chromium}"
      ]
    else
      [
        "--set-default"
        "USE_CHROME"
        "False"
      ]
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source self-hosted web archiving";
    longDescription = ''
      ArchiveBox is a powerful, self-hosted internet archiving solution to collect, save,
      and view websites offline. It supports multiple output formats (WARC, HTML, PDF,
      screenshot, and more) and can be extended with plugins via the abx-plugins ecosystem.
    '';
    homepage = "https://archivebox.io";
    changelog = "https://github.com/ArchiveBox/ArchiveBox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    mainProgram = "archivebox";
  };
})
