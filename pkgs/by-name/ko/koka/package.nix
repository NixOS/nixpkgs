{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsHostTarget,
  haskellPackages,
  cmake,
  makeWrapper,
}:

let
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "koka-lang";
    repo = "koka";
    rev = "v${version}";
    hash = "sha256-k1N085NoAlxewAhg5UDMo7IUf2A6gCTc9k5MWMbU0d0=";
    fetchSubmodules = true;
  };

  kklib = stdenv.mkDerivation {
    pname = "kklib";
    inherit version;
    src = "${src}/kklib";
    nativeBuildInputs = [ cmake ];
    outputs = [
      "out"
      "dev"
    ];
    postInstall = ''
      mkdir -p ''${!outputDev}/share/koka/v${version}
      cp -a ../../kklib ''${!outputDev}/share/koka/v${version}
    '';
  };

  inherit (pkgsHostTarget.targetPackages.stdenv) cc;
  runtimeDeps = [
    cc
    cc.bintools.bintools
    pkgsHostTarget.gnumake
    pkgsHostTarget.cmake
  ];
in
haskellPackages.mkDerivation {
  pname = "koka";
  inherit version src;

  isLibrary = false;
  isExecutable = true;

  buildTools = [ makeWrapper ];

  libraryToolDepends = with haskellPackages; [
    hpack
  ];

  executableHaskellDepends = with haskellPackages; [
    FloatingHex
    aeson
    array
    async
    base
    bytestring
    co-log-core
    containers
    directory
    hashable
    isocline
    lens
    lsp
    mtl
    network
    network-simple
    parsec
    process
    stm
    text
    text-rope
    time
    kklib
  ];

  executableToolDepends = with haskellPackages; [
    alex
  ];

  postInstall = ''
    mkdir -p $out/share/koka/v${version}
    cp -a lib $out/share/koka/v${version}
    ln -s ${kklib.dev}/share/koka/v${version}/kklib $out/share/koka/v${version}
    wrapProgram "$out/bin/koka" \
      --set CC "${lib.getBin cc}/bin/${cc.targetPrefix}cc" \
      --prefix PATH : "${lib.makeSearchPath "bin" runtimeDeps}"
  '';

  doHaddock = false;

  doCheck = false;

  prePatch = "hpack";

  description = "Koka language compiler and interpreter";
  homepage = "https://github.com/koka-lang/koka";
  changelog = "https://github.com/koka-lang/koka/blob/v${version}/doc/spec/news.mdk";
  license = lib.licenses.asl20;
  maintainers = with lib.maintainers; [
    siraben
    sternenseemann
  ];
}
