{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  readline,
  bison,
}:

stdenv.mkDerivation rec {

  pname = "es";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/wryun/es-shell/releases/download/v${version}/es-${version}.tar.gz";
    sha256 = "sha256-ySZIK0IITpA+uHHuHrDO/Ana5vGt64QI3Z6TMDXE9d0=";
  };

  # The distribution tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

  patches = [
    (fetchpatch {
      # https://github.com/wryun/es-shell/pull/101
      name = "new-compiler-issues.patch";
      url = "https://github.com/wryun/es-shell/commit/1eafb5fc4be735e59c9a091cc30adbca8f86fd96.patch";
      hash = "sha256-0CV1seEiH6PsUnq0akPLiRMy+kIb9qnAK7Ta4I47i60=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ bison ];
  buildInputs = [ readline ];

  configureFlags = [ "--with-readline" ];

  meta = with lib; {
    description = "Extensible shell with higher order functions";
    mainProgram = "es";
    longDescription = ''
      Es is an extensible shell. The language was derived
      from the Plan 9 shell, rc, and was influenced by
      functional programming languages, such as Scheme,
      and the Tcl embeddable programming language.
    '';
    homepage = "http://wryun.github.io/es-shell/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [
      sjmackenzie
      ttuegel
    ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/es";
  };
}
