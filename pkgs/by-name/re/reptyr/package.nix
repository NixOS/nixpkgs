{ stdenv, lib, fetchFromGitHub, python3 }:

let
  python = python3.withPackages (p: [ p.pexpect ]);
in stdenv.mkDerivation rec {
  version = "0.10.0";
  pname = "reptyr";

  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "reptyr";
    rev = "reptyr-${version}";
    sha256 = "sha256-jlO/ykrwGJkgKiPxfRQEX4TSksrbPQhkQs+QddwqaQ4=";
  };

  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  nativeCheckInputs = [ python ];

  # reptyr needs to do ptrace of a non-child process
  # It can be neither used nor tested if the kernel is not told to allow this
  doCheck = false;

  checkFlags = [
    "PYTHON_CMD=${python.interpreter}"
  ];

  meta = {
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "i686-freebsd"
      "x86_64-freebsd"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
      "riscv64-linux"
    ];
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.mit;
    description = "Reparent a running program to a new terminal";
    mainProgram = "reptyr";
    homepage = "https://github.com/nelhage/reptyr";
  };
}
