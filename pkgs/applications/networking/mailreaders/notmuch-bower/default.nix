{ lib, stdenv, fetchFromGitHub, mercury, pandoc, ncurses, gpgme, coreutils, file }:

stdenv.mkDerivation rec {
  pname = "notmuch-bower";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    rev = version;
    sha256 = "sha256-BNuJEVuzreI2AK/fqVMRHq8ZhPQjO33Y2FzkrWlfmm0=";
  };

  nativeBuildInputs = [ mercury pandoc ];
  postPatch = ''
    substituteInPlace src/compose.m --replace 'shell_quoted("base64' 'shell_quoted("${coreutils}/bin/base64'
    substituteInPlace src/detect_mime_type.m --replace 'shell_quoted("file' 'shell_quoted("${file}/bin/file'
  '';

  buildInputs = [ ncurses gpgme ];

  makeFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv bower $out/bin/
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/wangp/bower";
    description = "Curses terminal client for the Notmuch email system";
    mainProgram = "bower";
    maintainers = with maintainers; [ jgart ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
