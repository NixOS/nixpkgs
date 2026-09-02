{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pkg-config,
  elfutils,
  xz,
  autoconf,
  automake,
  gcc,
  libtool,
  gnumake,
  libkdumpfile,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "drgn";
  version = "0.0.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osandov";
    repo = "drgn";
    tag = "v${version}";
    hash = "sha256-ge1sDQrjoKYeGRYD6l7qCSxKdTq5uqqLKy9Ghpyq7pQ=";
    fetchSubmodules = true;
  };

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [
    autoconf
    automake
    gcc
    gnumake
    libtool
    pkg-config
  ];

  buildInputs = [
    elfutils
    xz
    libkdumpfile
  ];

  meta = {
    description = "Programmable debugger for the Linux kernel";
    longDescription = ''
      drgn (pronounced “dragon”) is a debugger with an emphasis on programmability.
      drgn exposes the types and variables in a program for easy, expressive
      scripting in Python.
    '';
    homepage = "https://github.com/osandov/drgn";
    changelog = "https://github.com/osandov/drgn/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ panky ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "drgn";
  };
}
