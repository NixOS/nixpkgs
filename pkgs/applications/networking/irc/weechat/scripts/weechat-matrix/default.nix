{ buildPythonPackage, stdenv, python, fetchFromGitHub,
  pyopenssl, webcolors, future, atomicwrites,
  attrs, Logbook, pygments, cachetools, matrix-nio }:

let
  matrixUploadPython = python.withPackages (ps: with ps; [
    magic
  ]);
in buildPythonPackage {
  pname = "weechat-matrix";
  version = "unstable-2019-11-10";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix";
    rev = "69ad2a9c03d516c212d3d0700dbb2bfe654f6365";
    sha256 = "1mfbkag5np2lgv6f31nyfnvavyh67jrrx6gxhzb8m99dd43lgs8c";
  };

  propagatedBuildInputs = [
    pyopenssl
    webcolors
    future
    atomicwrites
    attrs
    Logbook
    pygments
    cachetools
    matrix-nio
  ];

  passthru.scripts = [ "matrix.py" ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp $src/main.py $out/share/matrix.py

    cp $src/contrib/matrix_upload $out/bin/
    substituteInPlace $out/bin/matrix_upload \
      --replace '/usr/bin/env -S python3 -u' '${matrixUploadPython}/bin/python -u' 
  
    mkdir -p $out/${python.sitePackages}
    cp -r $src/matrix $out/${python.sitePackages}/matrix
  '';

  dontPatchShebangs = true;

  meta = with stdenv.lib; {
    description = "A Python plugin for Weechat that lets Weechat communicate over the Matrix protocol";
    homepage = "https://github.com/poljar/weechat-matrix";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = [ maintainers.tilpner ];
  };
}
