{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  sony-dump = fetchFromGitHub {
    name = "sony-dump";
    owner = "munjeni";
    repo = "anyxperia_dumper";
    rev = "2171258c9df50aba139b4bd1aa93295cd14d2262";
    hash = "sha256-kdHMDIX+ryx63A5TJMsqEZ4W36edC+dQrJKTeh5RFHA=";
  };
  zlib = fetchFromGitHub {
    name = "zlib-1.2.11";
    owner = "madler";
    repo = "zlib";
    tag = "v1.2.11";
    hash = "sha256-j5b6aki1ztrzfCqu8y729sPar8GpyQWIrajdzpJC+ww=";
  };
in
stdenv.mkDerivation {
  pname = "sony-dump";
  version = "0-unstable-2019-11-3";

  srcs = [
    sony-dump
    zlib
  ];

  sourceRoot = sony-dump.name;

  strictDeps = true;

  patches = [
    ./0001-Fix-makefile.patch
    ./0002-Fix-darwin-build.patch
  ];

  prePatch = ''
    cp -r ${zlib} ${zlib.name}
    chmod -R a+rwX ${zlib.name}
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 sony_dump -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/munjeni/anyxperia_dumper";
    description = "Tool to dump Sony Xperia boot images";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sony_dump";
  };
}
