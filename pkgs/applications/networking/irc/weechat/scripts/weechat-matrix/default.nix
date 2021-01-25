{ buildPythonPackage
, lib
, python
, fetchFromGitHub
, pyopenssl
, webcolors
, future
, atomicwrites
, attrs
, Logbook
, pygments
, matrix-nio
, aiohttp
, requests
}:

let
  scriptPython = python.withPackages (ps: with ps; [
    aiohttp
    requests
    python_magic
  ]);

  version = "0.2.0";
in buildPythonPackage {
  pname = "weechat-matrix";
  inherit version;

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix";
    rev = version;
    hash = "sha256-qsTdF9mGHac4rPs53mgoOElcujicRNXbJ7GsoptWSGc=";
  };

  propagatedBuildInputs = [
    pyopenssl
    webcolors
    future
    atomicwrites
    attrs
    Logbook
    pygments
    matrix-nio
    aiohttp
    requests
  ];

  passthru.scripts = [ "matrix.py" ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp $src/main.py $out/share/matrix.py

    cp $src/contrib/matrix_upload.py $out/bin/matrix_upload
    cp $src/contrib/matrix_decrypt.py $out/bin/matrix_decrypt
    cp $src/contrib/matrix_sso_helper.py $out/bin/matrix_sso_helper
    substituteInPlace $out/bin/matrix_upload \
      --replace '/usr/bin/env -S python3' '${scriptPython}/bin/python'
    substituteInPlace $out/bin/matrix_sso_helper \
      --replace '/usr/bin/env -S python3' '${scriptPython}/bin/python'
    substituteInPlace $out/bin/matrix_decrypt \
      --replace '/usr/bin/env python3' '${scriptPython}/bin/python'

    mkdir -p $out/${python.sitePackages}
    cp -r $src/matrix $out/${python.sitePackages}/matrix
  '';

  dontPatchShebangs = true;

  meta = with lib; {
    description = "A Python plugin for Weechat that lets Weechat communicate over the Matrix protocol";
    homepage = "https://github.com/poljar/weechat-matrix";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tilpner emily ];
  };
}
