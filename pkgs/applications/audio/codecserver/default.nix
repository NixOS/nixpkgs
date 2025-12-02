{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  udev,
  protobuf,
}:

stdenv.mkDerivation rec {
  pname = "codecserver";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "codecserver";
    rev = version;
    sha256 = "sha256-JzaVBFl3JsFNDm4gy1qOKA9uAjUjNeMiI39l5gfH0aE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  propagatedBuildInputs = [ protobuf ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/codecserver.pc \
      --replace-fail '=''${prefix}//' '=/' \
      --replace-fail '=''${exec_prefix}//' '=/'
  '';

  meta = with lib; {
    homepage = "https://github.com/jketterl/codecserver";
    description = "Modular audio codec server";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    mainProgram = "codecserver";
  };
}
