{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXft,
  libXrandr,
  swi-prolog,
}:

stdenv.mkDerivation rec {
  pname = "plwm";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Seeker04";
    repo = "plwm";
    tag = "v${version}";
    hash = "sha256-BeqANNV3PZZGsEzy3EMtWLbLzFto/ROhLM0jqPVyDCQ=";
  };

  patches = [
    ./001-define-utf8-encoding.patch
    ./002-rewrite-paths-for-nix.patch
  ];

  buildInputs = [
    libX11
    libXft
    libXrandr
    swi-prolog
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --subst-var-by swi-prolog ${swi-prolog} \
      --subst-var-by plwm $out
  '';

  # Don't strip as this would remove the saved state data needed for a
  # stand-alone prolog executable.
  # See https://github.com/SWI-Prolog/swipl-devel/issues/1370
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 bin/plwm -t $out/bin/
    install -Dm555 bin/plx.so -t $out/lib/
    install -Dm444 docs/plwm.1 -t $out/share/man/man1/
    install -Dm444 config/config.pl -t $out/share/doc/plwm/examples/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Seeker04/plwm/";
    changelog = "https://github.com/Seeker04/plwm/blob/${src.rev}/docs/CHANGELOG.md";
    description = "X11 window manager written in Prolog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.timow ];
    inherit (libX11.meta) platforms;
    mainProgram = "plwm";
  };
}
