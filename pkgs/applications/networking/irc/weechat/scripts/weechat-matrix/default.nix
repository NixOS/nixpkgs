{ buildPythonPackage
, lib
, python
, fetchFromGitHub
, fetchpatch
, pyopenssl
, webcolors
, future
, atomicwrites
, attrs
, logbook
, pygments
, matrix-nio
, aiohttp
, requests
}:

let
  scriptPython = python.withPackages (ps: with ps; [
    aiohttp
    requests
    python-magic
  ]);

  version = "0.3.0";
in buildPythonPackage {
  pname = "weechat-matrix";
  inherit version;

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix";
    rev = version;
    hash = "sha256-o4kgneszVLENG167nWnk2FxM+PsMzi+PSyMUMIktZcc=";
  };

  patches = [
    # server: remove set_npn_protocols()
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/poljar/weechat-matrix/pull/309.patch";
      hash = "sha256-Grdht+TOFvCYRpL7uhPivqL7YzLoNVF3iQNHgbv1Te0=";
    })
    # Fix compatibility with matrix-nio 0.21
    (fetchpatch {
      url = "https://github.com/poljar/weechat-matrix/commit/feae9fda26ea9de98da9cd6733980a203115537e.patch";
      hash = "sha256-MAfxJ85dqz5PNwp/GJdHA2VvXVdWh+Ayx5g0oHiw9rs=";
      includes = ["matrix/config.py"];
    })
  ];

  propagatedBuildInputs = [
    pyopenssl
    webcolors
    future
    atomicwrites
    attrs
    logbook
    pygments
    matrix-nio
    aiohttp
    requests
  ] ++ matrix-nio.optional-dependencies.e2e;

  passthru.scripts = [ "matrix.py" ];

  dontBuild = true;
  doCheck = false;

  format = "other";

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp main.py $out/share/matrix.py

    cp contrib/matrix_upload.py $out/bin/matrix_upload
    cp contrib/matrix_decrypt.py $out/bin/matrix_decrypt
    cp contrib/matrix_sso_helper.py $out/bin/matrix_sso_helper
    substituteInPlace $out/bin/matrix_upload \
      --replace-fail '/usr/bin/env -S python3' '${scriptPython}/bin/python'
    substituteInPlace $out/bin/matrix_sso_helper \
      --replace-fail '/usr/bin/env -S python3' '${scriptPython}/bin/python'
    substituteInPlace $out/bin/matrix_decrypt \
      --replace-fail '/usr/bin/env python3' '${scriptPython}/bin/python'

    mkdir -p $out/${python.sitePackages}
    cp -r matrix $out/${python.sitePackages}/matrix
  '';

  dontPatchShebangs = true;
  postFixup = ''
    addToSearchPath program_PYTHONPATH $out/${python.sitePackages}
    patchPythonScript $out/share/matrix.py
    substituteInPlace $out/${python.sitePackages}/matrix/server.py --replace-fail \"matrix_sso_helper\" \"$out/bin/matrix_sso_helper\"
    substituteInPlace $out/${python.sitePackages}/matrix/uploads.py --replace-fail \"matrix_upload\" \"$out/bin/matrix_upload\"
  '';

  meta = with lib; {
    description = "Python plugin for Weechat that lets Weechat communicate over the Matrix protocol";
    homepage = "https://github.com/poljar/weechat-matrix";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tilpner emily ];
  };
}
