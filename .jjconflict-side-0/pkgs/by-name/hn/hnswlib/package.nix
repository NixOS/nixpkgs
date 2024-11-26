{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:
let
  python = python3.withPackages (
    ps: with ps; [
      numpy
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "hnswlib";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nmslib";
    repo = "hnswlib";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-1KkAX42j/I06KO4wCnDsDifN1JiENqYKR5NNHBjyuVA=";
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
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/nmslib/hnswlib";
    changelog = "https://github.com/nmslib/hnswlib/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
