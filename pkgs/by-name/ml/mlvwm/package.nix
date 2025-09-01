{
  lib,
  stdenv,
  fetchFromGitHub,
  gccmakedep,
  libX11,
  libXext,
  libXpm,
  imake,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "mlvwm";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "morgant";
    repo = "mlvwm";
    rev = version;
    sha256 = "sha256-ElKmi+ANuB3LPwZTMcr5HEMESjDwENbYnNIGdRP24d0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    gccmakedep
    libX11
    libXext
    libXpm
    imake
  ];

  buildPhase = ''
    (cd man && xmkmf)
    (cd sample_rc && xmkmf)
    (cd mlvwm && xmkmf)
    xmkmf
    make
  '';

  installPhase = ''
    mkdir -p $out/{bin,etc}
    cp mlvwm/mlvwm $out/bin
    cp sample_rc/Mlvwmrc* $out/etc
    runHook postInstall
  '';

  postInstall = ''
    mv man/mlvwm.man man/mlvwm.1
    installManPage man/mlvwm.1
  '';

  meta = with lib; {
    homepage = "https://github.com/morgant/mlvwm";
    description = "Macintosh-like Virtual Window Manager";
    license = licenses.mit;
    longDescription = ''
      MLVWM or Macintosh-Like Virtual Window Manager,
      is an FVWM descendant created by Takashi Hasegawa
      in 1997 while studying at Nagoya University and
      was written entirely in the C programming language.
      As its name implies, it attempts to emulate the
      pre-Mac OS X Macintosh look and feel in its layout and window design.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.j0hax ];
    mainProgram = "mlvwm";
  };
}
