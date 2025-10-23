{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fribidi,
  libGL,
  libGLU,
  sfml_2,
  taglib,
}:
stdenv.mkDerivation {
  pname = "mars";
  version = "0-unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "thelaui";
    repo = "M.A.R.S.";
    rev = "84664cda094efe6e49d9b1550e4f4f98c33eefa2";
    hash = "sha256-SWLP926SyVTjn+UT1DCaJSo4Ue0RbyzImVnlNJQksS0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    fribidi
    libGL
    libGLU
    sfml_2
    taglib
  ];

  installPhase = ''
    runHook preInstall

    cd ..
    mkdir -p "$out/share/mars/"
    mkdir -p "$out/bin/"
    cp -rv data resources credits.txt license.txt "$out/share/mars/"
    cp -v marsshooter "$out/bin/mars.bin"
    cat << EOF > "$out/bin/mars"
    #! ${stdenv.shell}
    cd "$out/share/mars/"
    exec "$out/bin/mars.bin" "\$@"
    EOF
    chmod +x "$out/bin/mars"

    runHook postInstall
  '';

  meta = {
    homepage = "https://mars-game.sourceforge.net/";
    description = "Game about fighting with ships in a 2D space setting";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "mars";
  };
}
