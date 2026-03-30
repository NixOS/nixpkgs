{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  i3lock,
}:

stdenv.mkDerivation {
  pname = "i3lock-fancy-rapid";
  version = "unstable-2021-04-21";

  src = fetchFromGitHub {
    owner = "yvbbrjdr";
    repo = "i3lock-fancy-rapid";
    rev = "6eeebd4caa177b82fa5010b5e8828cce3f89fb97";
    hash = "sha256-EoX8ts0yV/zkb4wgEh4P8noU+UraRS4w9pp+76v+Nm0=";
  };

  buildInputs = [ libx11 ];

  propagatedBuildInputs = [ i3lock ];

  postPatch = ''
    substituteInPlace i3lock-fancy-rapid.c \
      --replace '"i3lock"' '"${i3lock}/bin/i3lock"'
  '';

  installPhase = ''
    runHook preInstall

    install -D i3lock-fancy-rapid $out/bin/i3lock-fancy-rapid
    ln -s $out/bin/i3lock-fancy-rapid $out/bin/i3lock

    runHook postInstall
  '';

  meta = {
    description = "Faster implementation of i3lock-fancy";
    homepage = "https://github.com/yvbbrjdr/i3lock-fancy-rapid";
    maintainers = with lib.maintainers; [ nickhu ];
    mainProgram = "i3lock-fancy-rapid";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
