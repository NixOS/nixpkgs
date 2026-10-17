{
  lib,
  fetchFromGitHub,
  python3,
  rustPlatform,

  # dependencies
  file,

  optionalDeps ? [
    bat
    fd
    poppler-utils
    ripgrep
    wl-clipboard-rs
    xclip
    xdg-utils
    zoxide
  ],
  extraPackages ? [ ],

  # optional dependencies
  bat,
  fd,
  poppler-utils,
  ripgrep,
  wl-clipboard-rs,
  xclip,
  xdg-utils,
  zoxide,
}:

let
  runtimePaths = [ file ] ++ optionalDeps ++ extraPackages;

  # needs >= 0.12.0; nixpkgs is 0.11.28
  # TODO: drop this override once https://github.com/NixOS/nixpkgs/pull/554025
  # ([python-updates] major updates 2026-08-18) reaches master and replace with default `uv_build`
  uv-build-0_12 = python3.pkgs.uv-build.overrideAttrs (
    finalAttrs: _oldAttrs: {
      version = "0.12.5";

      src = fetchFromGitHub {
        owner = "astral-sh";
        repo = "uv";
        tag = finalAttrs.version;
        hash = "sha256-tKdqciPQnteeTqkXtWY8mliWUDv5gMdU8x0UPadQZlQ=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-27NzA/YXYbcGO6ehXP9OgvgLJQG/YP/I+eeflLmzxRQ=";
      };
    }
  );

  # needs >= 2.2.0; nixpkgs is 1.30
  # TODO: drop this override once https://github.com/NixOS/nixpkgs/pull/554025
  # ([python-updates] major updates 2026-08-18) reaches master and replace with default `puremagic`
  puremagic-2 = python3.pkgs.puremagic.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "2.2.0";

      src = fetchFromGitHub {
        owner = "cdgriffith";
        repo = "puremagic";
        tag = finalAttrs.version;
        hash = "sha256-Mvhn/1xcgYgVkWok2qZXAe40pocfu6nJo5xuPruw2dc=";
      };

      passthru = oldAttrs.passthru // {
        build-system = with python3.pkgs; [
          setuptools
          setuptools-scm
        ];
      };
    }
  );
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "rovr";
  version = "0.10.1.post1";
  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "NSPC911";
    repo = "rovr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fgeU1KavaJ3bdRnq+236c5B37Qs8n3/eB8fXhN8BY3Q=";
  };

  __structuredAttrs = true;

  build-system = [
    uv-build-0_12
  ];

  # NOTE: backports-zstd is also a dependency, but only below Python 3.14
  dependencies = with python3.pkgs; [
    fastjsonschema
    humanize
    multiarchive
    pathvalidate
    pillow
    platformdirs
    puremagic-2
    pygments
    pytrash
    rarfile
    resvg-py
    rich
    textual
    textual-autocomplete
    textual-drivers
    textual-image
    tomli
    typing-extensions
  ];

  # Upstream pins rich==14.2.0; nixpkgs is 15.
  pythonRelaxDeps = [
    "rich"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath runtimePaths)
  ];

  pythonImportsCheck = [
    "rovr"
  ];

  meta = {
    description = "Terminal file manager built with Python's Textual framework";
    homepage = "https://github.com/NSPC911/rovr";
    changelog = "https://github.com/NSPC911/rovr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "rovr";
    maintainers = with lib.maintainers; [ kangazero ];
  };
})
