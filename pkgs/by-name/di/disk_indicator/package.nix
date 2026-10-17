{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "disk-indicator";
  version = "0.2.1-unstable-2018-12-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MeanEYE";
    repo = "Disk-Indicator";
    rev = "ec2d2f6833f038f07a72d15e2d52625c23e10b12";
    sha256 = "sha256-cRqgIxF6H1WyJs5hhaAXVdWAlv6t22BZLp3p/qRlCSM=";
  };

  buildInputs = [ libx11 ];

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    # avoid -Werror
    substituteInPlace Makefile --replace-fail "-Werror" ""
    # avoid host-specific options
    substituteInPlace Makefile --replace-fail "-march=native" ""
    # fix signal handler signature
    substituteInPlace src/main.c --replace-fail "void handle_signal()" "void handle_signal(int sig)"
  '';

  configureScript = "./configure.sh";

  makeFlags = [
    "COMPILER=${lib.getExe stdenv.cc}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    installBin disk_indicator
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/MeanEYE/Disk-Indicator";
    description = "Program that will turn a LED into a hard disk indicator";
    mainProgram = "disk_indicator";
    longDescription = ''
      Small program for Linux that will turn your Scroll, Caps or Num Lock LED
      or LED on your ThinkPad laptop into a hard disk activity indicator.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
