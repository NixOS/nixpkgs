{
  lib,
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
  nixosTests,

  python3,
}:
let
  python = python3;
in
python.pkgs.buildPythonPackage (finalAttrs: {
  pname = "pdfding";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "mrmn2";
    repo = "PdfDing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXkD+2k8/LmMWzZAj8qEK4mLoOKS4mDWcqe8AgoCdBU=";
  };
  pyproject = true;

  patches = [
    # fixes two tests, remove patch in the next version
    # https://github.com/mrmn2/PdfDing/pull/248
    (fetchpatch2 {
      url = "https://github.com/mrmn2/PdfDing/commit/24df5a82ffb1d60162978791b716f67d20128a22.patch?full_index=1";
      hash = "sha256-N3FtPQGSOFeUbVcinXK9kJM6hZOn4YdJJVWe4VXb8pE=";
    })
  ];

  # remove supervisor from dependencies
  postPatch = ''
    sed -i 's/supervisor.*$//' pyproject.toml

    substituteInPlace pdfding/backup/tests/test_management.py pdfding/backup/tests/test_tasks.py \
      --replace-fail "Path(__file__).parents[2]" "Path('$PDFDING_OUT_DIR')"
  '';

  dependencies =
    with python.pkgs;
    [
      django
      django-allauth
      django-cleanup
      django-htmx
      gunicorn
      huey
      markdown
      minio
      nh3
      oauthlib
      pillow
      psycopg2-binary
      pypdf
      pypdfium2
      python-magic
      qrcode
      rapidfuzz
      ruamel-yaml
      whitenoise

      # dependecies required for django collectstatic
      cryptography
      pyjwt
      requests
    ]
    ++ qrcode.optional-dependencies.pil
    ++ django-allauth.optional-dependencies.socialaccount;

  build-system = with python.pkgs; [ poetry-core ];

  nativeBuildInputs = [
    makeWrapper
  ];

  optional-dependencies = {
    e2e = with python.pkgs; [
      pytest
      pytest-django
      pytest-playwright
      pytest-rerunfailures # required to retry some flaky e2e tests
    ];
  };

  preBuild = ''
    # remove originals, copy from frontend
    rm -rf pdfding/static
    ln -s ${finalAttrs.passthru.frontend}/pdfding/static pdfding/static

    # staticfiles step requires prod configuration, remove dev.py
    mv pdfding/core/settings/dev.py dev.py.bak

    ${python.pythonOnBuildForHost.interpreter} pdfding/manage.py collectstatic

    # not needed, now we have staticfiles directory
    rm -rf pdfding/static

    # the following is from upstream's Dockerfile

    # remove django md5 hash from filenames of pdfjs as it will mess up the relative imports because of the whitenoise setup
    export PDFJS_PATH="pdfding/staticfiles/pdfjs"
    for file_name in $(find $PDFJS_PATH -type f -not -path "$PDFJS_PATH/web/images/*")
    do
      if [[ $file_name =~ "LICENSE" ]]; then
        new=$(echo "$file_name" | sed -E "s/LICENSE\.[a-zA-Z0-9]{12}/LICENSE/");
      else
        new=$(echo "$file_name" | sed -E "s/\.[a-zA-Z0-9]{12}\./\./");
      fi;
      mv -- "$file_name" "$new";
    done \
    && echo 'Successfully removed hash from pdfjs files'

    echo "VERSION = '${finalAttrs.version}'" > pdfding/core/settings/version.py;
  '';

  env.PDFDING_OUT_DIR = "${placeholder "out"}/${python.sitePackages}/pdfding";

  makeWrapperArgs = [
    "--set-default DATA_DIR /var/lib/pdfding"
    # allow for gunicorn processes to have access to Python packages
    "--prefix PYTHONPATH : "
    "${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}:${finalAttrs.env.PDFDING_OUT_DIR}"
  ];

  postInstall = ''
    mkdir -p $out/bin

    makeWrapper "$PDFDING_OUT_DIR/manage.py" $out/bin/pdfding-manage \
      $makeWrapperArgs

    makeWrapper ${lib.getExe python.pkgs.gunicorn} $out/bin/pdfding-start \
      --add-flags '--bind ''${HOST_IP:-127.0.0.1}:''${HOST_PORT:-8080} core.wsgi:application' \
      $makeWrapperArgs
  '';

  pythonRelaxDeps = [
    "django"
    "django-allauth"
    "django-htmx"
    "pypdf"
    "ruamel-yaml"
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest-django
    pytestCheckHook
  ];

  # from .github/workflows/tests.yaml
  pytestFlags = [
    "--ignore=e2e"
  ];

  disabledTests = [
    # broken tests in 1.5.0
    "test_adjust_file_paths_to_ws_collection"
    "test_oidc_callback" # AssertionError: 200 != 401
  ];

  /*
    fix two breaking tests by providing full out path
    AssertionError: Calls not found
    AssertionError: 'add_file_to_minio' does not contain all of ...
  */
  preCheck = ''
    # dev.py is required for tests, restore it
    mv dev.py.bak $PDFDING_OUT_DIR/core/settings/dev.py

    # tests should run in pdfding directory
    pushd pdfding
  '';

  postCheck = ''
    # come out of the pdfding directory
    popd

    # remove dev.py
    rm $PDFDING_OUT_DIR/core/settings/dev.py
  '';

  pythonImportsCheck = [
    "pdfding"
  ];

  passthru = {
    inherit python;
    tests = nixosTests.pdfding;
    frontend = callPackage ./frontend.nix { };
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/mrmn2/PdfDing/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Selfhosted PDF manager, viewer and editor offering a seamless user experience on multiple devices";
    downloadPage = "https://github.com/mrmn2/PdfDing";
    homepage = "https://pdfding.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "pdfding-manage";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.unix;
    teams = with lib.teams; [ ngi ];
  };
})
