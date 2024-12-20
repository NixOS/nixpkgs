{
  lib,
  stdenv,
  fetchFromGitLab,
  eigen,
  makeWrapper,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "professor";
  version = "2.4.2";

  src = fetchFromGitLab {
    owner = "hepcedar";
    repo = "professor";
    rev = "refs/tags/professor-2.4.2";
    hash = "sha256-z2Ub7SUTz4Hj3ajnzOV/QXZ+cH2v6zJv9UZM2M2y1Hg=";
    # workaround unpacking to case-sensitive filesystems
    postFetch = ''
      rm -rf $out/[Dd]ocker
    '';
  };

  postPatch =
    ''
      substituteInPlace Makefile \
        --replace-fail 'pip install ' 'pip install --prefix $(out) '
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Makefile \
        --replace-fail '-shared -o' '-shared -install_name "$(out)/$@" -o'
    '';

  nativeBuildInputs = [
    python3.pkgs.cython
    python3.pkgs.pip
    python3.pkgs.setuptools
    python3.pkgs.wheel
    makeWrapper
  ];
  buildInputs = [
    python3
    eigen
  ];
  propagatedBuildInputs = with python3.pkgs; [
    iminuit
    numpy
    matplotlib
    yoda
  ];

  CPPFLAGS = [ "-I${eigen}/include/eigen3" ];
  PREFIX = placeholder "out";

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH "$PYTHONPATH:$(toPythonPath "$out")"
    done
  '';

  doInstallCheck = true;
  installCheckTarget = "check";

  meta = with lib; {
    description = "Tuning tool for Monte Carlo event generators";
    homepage = "https://professor.hepforge.org/";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
