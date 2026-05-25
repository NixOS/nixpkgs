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
  # Extra Python packages to add to the archivebox environment (e.g., abx-compatible plugins)
  extraPackages ? (_ps: [ ]),
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      # ArchiveBox 0.9.x requires Django >= 6.0
      django = super.django_6;
    };
  };
in

python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "archivebox";
  version = "0.9.31rc1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "ArchiveBox";
    rev = "c5d11c3224138d8ab84aa963429e9414a743bd6d";
    hash = "sha256-2FJRoXUSLfB0oVyKMKE98ZJRIsBq12Rr91gIGBBohcg=";
  };

  build-system = with python.pkgs; [
    pdm-backend
  ];

  # Dependencies are ordered the same way that upstream does in their pyproject.toml
  # so that it is easier to tell if dependencies are added/removed on upgrade
  dependencies =
    with python.pkgs;
    [
      ### Django libraries
      setuptools
      django
      daphne
      # doCheck disabled: django-ninja's tests fail in the Nix sandbox due to missing test database setup
      (django-ninja.overridePythonAttrs { doCheck = false; })
      django-extensions
      django-signal-webhooks
      django-admin-data-views
      django-object-actions
      django-taggit

      ### State management
      python-statemachine

      ### CLI / Logging
      click
      rich
      rich-click
      ipython

      ### Host OS / System
      supervisor
      psutil
      platformdirs
      py-machineid
      atomicwrites

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
    ++ (extraPackages python.pkgs);

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
