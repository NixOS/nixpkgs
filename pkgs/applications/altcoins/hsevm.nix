{ mkDerivation, abstract-par, aeson, ansi-wl-pprint, base
, base16-bytestring, base64-bytestring, binary, brick, bytestring
, cereal, containers, cryptonite, data-dword, deepseq, directory
, filepath, ghci-pretty, here, HUnit, lens, lens-aeson, memory
, monad-par, mtl, optparse-generic, process, QuickCheck
, quickcheck-text, readline, rosezipper, scientific, stdenv, tasty, tasty-hunit
, tasty-quickcheck, temporary, text, text-format
, unordered-containers, vector, vty
, fetchFromGitHub, lib, makeWrapper
, ncurses, zlib, bzip2, solc, coreutils
}:

lib.overrideDerivation (mkDerivation rec {
  pname = "hsevm";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "hsevm";
    rev = "v${version}";
    sha256 = "01b67k9cam4gvsi07q3vx527m1w6p6xll64k1nl27bc8ik6jh8l9";
  };

  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;

  postInstall = ''
    rm -rf $out/{lib,share}
    wrapProgram $out/bin/hsevm --add-flags '+RTS -N$((`${coreutils}/bin/nproc` - 1)) -RTS'
  '';

  extraLibraries = [
    abstract-par aeson ansi-wl-pprint base base16-bytestring
    base64-bytestring binary brick bytestring cereal containers
    cryptonite data-dword deepseq directory filepath ghci-pretty lens
    lens-aeson memory monad-par mtl optparse-generic process QuickCheck
    quickcheck-text readline rosezipper scientific temporary text text-format
    unordered-containers vector vty
  ];
  executableHaskellDepends = [
    readline zlib bzip2
  ];
  testHaskellDepends = [
    base binary bytestring ghci-pretty here HUnit lens mtl QuickCheck
    tasty tasty-hunit tasty-quickcheck text vector
  ];

  homepage = https://github.com/dapphub/hsevm;
  description = "Ethereum virtual machine evaluator";
  license = stdenv.lib.licenses.agpl3;
  maintainers = [stdenv.lib.maintainers.dbrock];
}) (attrs: {
  buildInputs = attrs.buildInputs ++ [solc];
  nativeBuildInputs = attrs.nativeBuildInputs ++ [makeWrapper];
})
