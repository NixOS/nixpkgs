{
  lib,
  stdenv,
  fetchFromGitLab,
  eigen,
  makeWrapper,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "professor";
  version = "2.5.8";

  src = fetchFromGitLab {
    owner = "hepcedar";
    repo = "professor";
    tag = "professor-${finalAttrs.version}";
    hash = "sha256-q1OxYnsr4xE7NSZekQq9AeMFPv1B+/VMu6ZttKPQsBs=";
    # workaround unpacking to case-sensitive filesystems
    postFetch = ''
      rm -rf $out/[Dd]ocker
    '';
  };

  postPatch = ''
    substituteInPlace configure \
      --replace-fail '$(which $PYTHON 2> /dev/null)' '$(command -v $PYTHON)' \
      --replace-fail '$(which $CYTHON 2> /dev/null)' '$(command -v $CYTHON)' \
      --replace-fail '$(which $ROOTCONFIG 2> /dev/null)' '$(command -v $ROOTCONFIG)'
    substituteInPlace Makefile \
      --replace-fail 'pip wheel' 'pip wheel --no-build-isolation'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail '-shared -o' '-shared -install_name "$(out)/$@" -o'
  '';

  configureFlags = [ "--with-eigen=${eigen}" ];

  env.PYTHON = "python3";

  nativeBuildInputs = [
    python3
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

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH "$PYTHONPATH:$(toPythonPath "$out")"
    done
  '';

  doInstallCheck = true;
  installCheckTarget = "check";

  meta = {
    description = "Tuning tool for Monte Carlo event generators";
    homepage = "https://professor.hepforge.org/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.veprbl ];
    platforms = lib.platforms.unix;
  };
})
