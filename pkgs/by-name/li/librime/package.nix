{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  glog,
  leveldb,
  marisa,
  opencc,
  yaml-cpp,
  gtest,
  capnproto,
  pkg-config,
  librime-lua,
  librime-octagram,
  plugins ? [
    librime-lua
    librime-octagram
  ],
}:

let
  copySinglePlugin = plug: "cp -r ${plug} plugins/${plug.name}";
  copyPlugins = ''
    mkdir -p plugins
    ${lib.concatMapStringsSep "\n" copySinglePlugin plugins}
    chmod +w -R plugins/*
  '';
in
stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = version;
    sha256 = "sha256-B3mhHv8fk8TGXu+jJSYJ2R8QW+nG5RJx6kFtP5ILhYY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    glog
    leveldb
    marisa
    opencc
    yaml-cpp
    gtest
    capnproto
  ]
  ++ plugins; # for propagated build inputs

  preConfigure = copyPlugins;

  meta = with lib; {
    homepage = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
