{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  squawk,
  protobufc,
  xxHash,
}:
stdenv.mkDerivation rec {
  pname = "libpg_query";
  version = "17-6.1.0";

  src = fetchFromGitHub {
    owner = "pganalyze";
    repo = "libpg_query";
    tag = version;
    hash = "sha256-UXba2WYyIO7RcFcNZeLL+Q9CwlloMZ5oFfHfL7+j4dU=";
  };

  nativeBuildInputs = [ which ];

  makeFlags = [
    "build"
    "build_shared"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 libpg_query.a -t $out/lib
    install -Dm644 libpg_query${stdenv.hostPlatform.extensions.sharedLibrary} -t $out/lib
    cp -r src/include $out/include
    cp -r src/postgres/include/* $out/include
    cp -r protobuf $out/include/protobuf
    ln -s ${protobufc.dev}/include/protobuf-c $out/include/protobuf-c
    cp -r ${protobufc.dev}/include/protobuf-c/* $out/include
    ln -s ${xxHash}/include $out/include/xxhash
    install -Dm644 pg_query.h -t $out/include

    runHook postInstall
  '';

  doCheck = true;

  checkTarget = "test";

  passthru.tests = {
    inherit squawk;
  };

  meta = {
    homepage = "https://github.com/pganalyze/libpg_query";
    description = "C library for accessing the PostgreSQL parser outside of the server environment";
    changelog = "https://github.com/pganalyze/libpg_query/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
