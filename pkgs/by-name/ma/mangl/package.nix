{
  stdenv,
  fetchFromGitHub,
  lib,
  glfw,
  freetype,
  pkg-config,
  bzip2,
  zlib,
}:

stdenv.mkDerivation {
  pname = "mangl";
  version = "1.1.5-unstable-2024-07-10";
  src = fetchFromGitHub {
    owner = "zigalenarcic";
    repo = "mangl";
    rev = "9d369fb0b9637969bbdfaafca73832fe8a31445b";
    hash = "sha256-22JnflZtlkjI3wr6UHweb77pOk9cMwF+c6KORutCSDM=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    glfw
    bzip2
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0555 mangl -t $out/bin
    install -Dm0444 mangl.1 -t $out/man/man1
    install -Dm0444 art/mangl.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm0444 mangl.desktop -t $out/share/applications

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/zigalenarcic/mangl";
    description = "A graphical man page viewer based on the mandoc library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrabulinski ];
    platforms = platforms.linux;
    mainProgram = "mangl";
  };
}
