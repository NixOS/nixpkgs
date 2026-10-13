{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  unstableGitUpdater,
}:
let
  python = python3.override {
    packageOverrides = final: prev: { };
  };
in
python.pkgs.buildPythonPackage (finalAttrs: {
  pname = "searxng";
  version = "0-unstable-2026-10-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "searxng";
    repo = "searxng";
    rev = "19ffbcd30686e4008392e93de164200510dfb9d8";
    hash = "sha256-iYItwi8cZvJLpnNW3VXQtTNwZMe3DKtAYe4F/VFbjhw=";
  };

  postPatch = ''
    # some of them will be fixed with https://github.com/NixOS/nixpkgs/pull/554025
    sed -i requirements.txt \
      -e 's/certifi==.*/certifi/' \
      -e 's/lxml==.*/lxml/' \
      -e 's/pygments==.*/pygments/' \
      -e 's/curl_cffi==.*/curl_cffi/' \
      -e 's/msgspec==.*/msgspec/' \
      -e 's/typer==.*/typer/'

    substituteInPlace requirements.txt \
      --replace-fail "==" ">="
  '';

  nativeBuildInputs = with python.pkgs; [ pythonRelaxDepsHook ];

  pythonRelaxDeps = true;

  preBuild =
    let
      versionString = lib.concatStringsSep "." (
        map (lib.removePrefix "0") (
          builtins.tail (lib.splitString "-" (lib.removePrefix "0-" finalAttrs.version))
        )
      );
      commitAbbrev = builtins.substring 0 8 finalAttrs.src.rev;
    in
    ''
      export SEARX_DEBUG="true";

      cat > searx/version_frozen.py <<EOF
      VERSION_STRING="${versionString}+${commitAbbrev}"
      VERSION_TAG="${versionString}+${commitAbbrev}"
      DOCKER_TAG="${versionString}-${commitAbbrev}"
      GIT_URL="https://github.com/searxng/searxng"
      GIT_BRANCH="master"
      EOF
    '';

  build-system = with python.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    babel
    certifi
    cloudscraper
    curl-cffi
    flask
    flask-babel
    isodate
    jinja2
    lxml
    markdown-it-py
    msgspec
    pygments
    python-dateutil
    pyyaml
    typer
    typing-extensions
    valkey
    whitenoise
  ];

  # tests try to connect to network
  doCheck = false;

  postInstall = ''
    PYTHONPATH=${
      python.withPackages (_: finalAttrs.passthru.dependencies)
    }/${python.sitePackages} ${lib.getExe python.pkgs.pip} install --break-system-packages --dry-run --no-index -r requirements.txt

    # Create a symlink for easier access to static data
    mkdir -p $out/share
    ln -s ../${python.sitePackages}/searx/static $out/share/

    # copy config schema for the limiter
    cp searx/limiter.toml $out/${python.sitePackages}/searx/limiter.toml
  '';

  passthru = {
    tests = {
      searxng = nixosTests.searx;
    };
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    homepage = "https://github.com/searxng/searxng";
    description = "Fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = lib.licenses.agpl3Plus;
    mainProgram = "searxng-run";
    maintainers = with lib.maintainers; [
      SuperSandro2000
      _999eagle
    ];
  };
})
