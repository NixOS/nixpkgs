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
  version = "unstable-2020-01-21";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix";
    rev = "46640df3e0bfb058e97d8abe723bb88fdf4e5177";
    sha256 = "1j3l43j741csfxsp1nsc74y6wj2wm86c45iraf167g6p0sdzcq8z";
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

    cp \
      $src/contrib/matrix_upload \
      $src/contrib/matrix_decrypt \
      $src/contrib/matrix_sso_helper \
      $out/bin/
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
