{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  installShellFiles,
  libftdi1,
  popt,
}:

stdenv.mkDerivation {
  pname = "sd-mux-ctrl-unstable";
  version = "2020-02-17";

  src = fetchgit {
    url = "https://git.tizen.org/cgit/tools/testlab/sd-mux";
    rev = "9dd189d973da64e033a0c5c2adb3d94b23153d94";
    hash = "sha256-b0uoxVPfSrqNt0wJoQho9jlpQQUjofgFm93P+UNFtDs=";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libftdi1
    popt
  ];

  postInstall = ''
    install -D -m 644 ../doc/man/sd-mux-ctrl.1 $out/share/man/man1/sd-mux-ctrl.1
    installShellCompletion --cmd sd-mux-ctrl \
      --bash ../etc/bash_completion.d/sd-mux-ctrl
  '';

  meta = with lib; {
    description = "Tool for controlling multiple sd-mux devices";
    homepage = "https://git.tizen.org/cgit/tools/testlab/sd-mux";
    license = licenses.asl20;
    maintainers = with maintainers; [
      newam
      sarcasticadmin
    ];
    platforms = platforms.unix;
    mainProgram = "sd-mux-ctrl";
  };
}
