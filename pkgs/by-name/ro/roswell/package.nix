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

stdenv.mkDerivation rec {
  pname = "roswell";
  version = "24.10.115";

  src = fetchFromGitHub {
    owner = "roswell";
    repo = "roswell";
    rev = "v${version}";
    hash = "sha256-2aYA1AzRPXaM82Sh+dMiQJcOAD0rzwV09VyLy0oS6as=";
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
    changelog = "https://github.com/roswell/roswell/blob/v${version}/ChangeLog";
    mainProgram = "ros";
  };
}
