{
  lib,
  python3,
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
}:
let
  python = python3;
in
python.pkgs.buildPythonPackage (finalAttrs: {
  pname = "pdfding";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "mrmn2";
    repo = "PdfDing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rrUaqxDO16NAOic74jeYgN+7Alvo+fIIacJdSOg0hFM=";
    # remove in 1.5.0
    postFetch = "mv $out/{license.txt,LICENSE}";
  };
  pyproject = true;

  patches = [
    # remove all patches in 1.5.0 (next version after 1.4.1)
    # patch to add data_dir
    (fetchpatch2 {
      url = "https://github.com/mrmn2/PdfDing/commit/f4945f2836ca8d972fcee2f00ef1d9cf217bada1.patch?full_index=1";
      hash = "sha256-VGjyIAVi+qd2WZ8FVKKC2ijLinoflO7RmPwIW1/oGcY=";
    })
    # pyproject.toml still has 0.1.1 very old version
    (fetchpatch2 {
      url = "https://github.com/mrmn2/PdfDing/pull/203.patch?full_index=1";
      hash = "sha256-lKtpqKdyoGZdU4fTegto+YUIduIWbM82RQU9459NpC0=";
    })
    # allows customising consume_schedule crontab
    (fetchpatch2 {
      url = "https://github.com/mrmn2/PdfDing/commit/96a13574718e0d27240eee8893fb799a02f24c05.patch?full_index=1";
      hash = "sha256-Stq392rIbsphvaE23GgFWb91KzpD6aOQu9MGDDoaO7s=";
    })
    # allow specifying region for s3 backups
    (fetchpatch2 {
      url = "https://github.com/mrmn2/PdfDing/commit/3e412654f62d83b745111bd1d3587aca1a7739e1.patch?full_index=1";
      hash = "sha256-RQS3yJjrIaViFlm6it6zyRZOn+nTQE8qr8OpY+zYSCY=";
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
      markdown
      minio
      nh3
      psycopg2-binary
      pypdf
      pypdfium2
      python-magic
      qrcode
      rapidfuzz
      ruamel-yaml
      whitenoise
      huey
      pillow
      oauthlib

      # dependecies required for django collectstatic
      requests
      pyjwt
      cryptography
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
    "huey"
    "minio"
    "pypdf"
    "pypdfium2"
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest-django
    pytestCheckHook
  ];

  # from .github/workflows/tests.yaml
  pytestFlags = [
    "--ignore=e2e"
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
    teams = with lib.teams; [ ngi ];
  };
})
