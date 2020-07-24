{ buildPythonPackage
, stdenv
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
in buildPythonPackage {
  pname = "weechat-matrix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix";
    rev = "65a5db7291439b6132e35e8cc09ed901614fabf6";
    sha256 = "0m3k5vrv5ab1aw1mjd0r8d71anwqzvncvv9v5zx9xp1i188sdm8x";
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

  meta = with stdenv.lib; {
    description = "A Python plugin for Weechat that lets Weechat communicate over the Matrix protocol";
    homepage = "https://github.com/poljar/weechat-matrix";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tilpner emily ];
  };
}
