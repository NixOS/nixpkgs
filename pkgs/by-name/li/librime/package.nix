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
stdenv.mkDerivation (finalAttrs: {
  pname = "librime";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = finalAttrs.version;
    sha256 = "sha256-Jbo6Svt/d00ZJwtYkWMKFeKzpFFYhbnm3m2alDxRGvU=";
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

  meta = {
    homepage = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vonfry ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
