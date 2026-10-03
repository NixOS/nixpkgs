{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  libx11,
  libxft,
  libxrandr,
  swi-prolog,
}:

stdenv.mkDerivation rec {
  pname = "plwm";
  version = "0.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Seeker04";
    repo = "plwm";
    tag = "v${version}";
    hash = "sha256-BeqANNV3PZZGsEzy3EMtWLbLzFto/ROhLM0jqPVyDCQ=";
  };

  patches = [
    ./001-rewrite-paths-for-nix.patch
    ./002-gcc-pragma-ignore-cast-error.patch
  ];

  nativeBuildInputs = [
    installShellFiles
    swi-prolog
  ];

  buildInputs = [
    libx11
    libxft
    libxrandr
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

    installBin bin/plwm
    install -Dm555 bin/plx.so -t $out/lib/
    installManPage docs/plwm.1
    install -Dm444 config/config.pl -t $out/share/doc/plwm/examples/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Seeker04/plwm/";
    changelog = "https://github.com/Seeker04/plwm/blob/${src.rev}/docs/CHANGELOG.md";
    description = "X11 window manager written in Prolog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.timow ];
    inherit (libx11.meta) platforms;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
    mainProgram = "plwm";
  };
}
