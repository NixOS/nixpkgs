{ lib, stdenv, fetchFromGitHub, fetchpatch, buildPackages, cmake, installShellFiles
, boost, lua, protobuf, rapidjson, shapelib, sqlite, zlib, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilemaker";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "systemed";
    repo = "tilemaker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xpOF/0qFuvTUWQ1I8x/gy5qSLKzSgcQahS47PG+bTRA=";
  };

  postPatch = ''
    substituteInPlace src/tilemaker.cpp \
      --replace "config.json" "$out/share/tilemaker/config-openmaptiles.json" \
      --replace "process.lua" "$out/share/tilemaker/process-openmaptiles.lua"
  '';

  nativeBuildInputs = [ cmake installShellFiles ];

  buildInputs = [ boost lua protobuf rapidjson shapelib sqlite zlib ];

  cmakeFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "-DPROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc";

  env.NIX_CFLAGS_COMPILE = toString [ "-DTM_VERSION=${finalAttrs.version}" ];

  postInstall = ''
    installManPage ../docs/man/tilemaker.1
    install -Dm644 ../resources/* -t $out/share/tilemaker
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "tilemaker --help";
  };

  meta = with lib; {
    description = "Make OpenStreetMap vector tiles without the stack";
    homepage = "https://tilemaker.org/";
    changelog = "https://github.com/systemed/tilemaker/blob/v${version}/CHANGELOG.md";
    license = licenses.free; # FTWPL
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
