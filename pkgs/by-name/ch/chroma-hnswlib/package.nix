{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:
let
  python = python3.withPackages(ps: with ps; [
    numpy
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "chroma-hnswlib";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "hnswlib";
    rev = "${finalAttrs.version}";
    hash = "sha256-c4FvymqZy8AZKbh6Y8xZRjKAqYcUyZABRGc1u7vwlsk=";
  };

  # this is a header-only library, so we don't need to build it
  # we need `cmake` only to run tests
  nativeCheckInputs = [
    cmake
    python
  ];

  # we only want to run buildPhase when we run tests
  dontBuild = !finalAttrs.finalPackage.doCheck;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/hnswlib/*.h -t $out/include/hnswlib

    runHook postInstall
  '';

  doCheck = true;

  preCheck = ''
    pushd ../tests/cpp
    ${python.interpreter} update_gen_data.py
    popd
  '';

  checkPhase = ''
    runHook preCheck

    ./test_updates

    runHook postCheck
  '';

  meta = with lib; {
    description = "Chroma's fork of hnswlib - a header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/chroma-core/hnswlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.unix;
  };
})
