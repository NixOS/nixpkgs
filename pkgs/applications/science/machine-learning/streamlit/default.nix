{
  # Nix
  lib,
  buildPythonApplication,
  fetchPypi,
  fetchpatch,

  unzip,
  zip,

  # Build inputs
  altair,
  astor,
  base58,
  blinker,
  boto3,
  botocore,
  click,
  cachetools,
  enum-compat,
  future,
  GitPython,
  jinja2,
  pillow,
  pyarrow,
  pydeck,
  pympler,
  protobuf,
  requests,
  setuptools,
  toml,
  tornado,
  tzlocal,
  validators,
  watchdog,
}:

let
  click_7 = click.overridePythonAttrs(old: rec {
    version = "7.1.2";
    src = old.src.override {
      inherit version;
      sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
    };
  });
in buildPythonApplication rec {
  pname = "streamlit";
  version = "1.2.0";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1dzb68a8n8wvjppcmqdaqnh925b2dg6rywv51ac9q09zjxb6z11n";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-35918.patch";
      url = "https://github.com/streamlit/streamlit/commit/80d9979d5f4a00217743d607078a1d867fad8acf.patch";
      sha256 = "sha256-AyVF/VUKUEKz0RF9CzW2eco0lY0xVd3hPc88D7VZ5Xw=";
      stripLen = 1;
      # tests not included in wheel
      excludes = [ "tests/streamlit/components_test.py" ];
    })
  ];
  # extract wheel, run normal patch phase, repack wheel.
  # effectively a "wheelPatchPhase". not a normal thing
  # to do but needs must.
  patchPhase = ''
    wheelFile="$(realpath -s dist/*.whl)"
    pushd "$(mktemp -d)"

    unzip -q "$wheelFile"

    patchPhase

    newZip="$(mktemp -d)"/new.zip
    zip -rq "$newZip" *
    rm -rf "$wheelFile"
    cp "$newZip" "$wheelFile"

    popd
  '';

  nativeBuildInputs = [ unzip zip ];

  propagatedBuildInputs = [
    altair
    astor
    base58
    blinker
    boto3
    botocore
    cachetools
    click_7
    enum-compat
    future
    GitPython
    jinja2
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    requests
    setuptools
    toml
    tornado
    tzlocal
    validators
    watchdog
  ];

  postInstall = ''
      rm $out/bin/streamlit.cmd # remove windows helper
  '';

  meta = with lib; {
    homepage = "https://streamlit.io/";
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };
}
