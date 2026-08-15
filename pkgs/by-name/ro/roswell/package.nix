{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  autoconf,
  automake,
  makeWrapper,
  sbcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "roswell";
  version = "26.02.116";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = "roswell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-saKCLr1Nmzl+zcPbYSXt7o82hh6vYhACCfUUzEs/31E=";
  };

  patches = [
    # Load the name of the image from the environment variable so that
    # it can be consistently overwritten. Using the command line
    # argument in the wrapper did not work.
    ./0001-get-image-from-environment.patch
  ];

  preConfigure = ''
    sh bootstrap
  '';

  configureFlags = [ "--prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/ros \
      --set image `basename $out` \
      --add-flags 'lisp=sbcl-bin/system sbcl-bin.version=system -L sbcl-bin' \
      --prefix PATH : ${lib.makeBinPath [ sbcl ]} --argv0 ros
  '';

  nativeBuildInputs = [
    autoconf
    automake
    makeWrapper
  ];

  buildInputs = [
    sbcl
    curl
  ];

  meta = {
    description = "Lisp implementation installer/manager and launcher";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hiro98 ];
    platforms = lib.platforms.unix;
    homepage = "https://github.com/roswell/roswell";
    changelog = "https://github.com/roswell/roswell/blob/${finalAttrs.src.tag}/ChangeLog";
    mainProgram = "ros";
  };
})
