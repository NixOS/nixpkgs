{ aeson, ansi-wl-pprint, base, base16-bytestring
, base64-bytestring, binary, brick, bytestring, containers
, cryptonite, data-dword, deepseq, directory, filepath, ghci-pretty
, here, HUnit, lens, lens-aeson, memory, mtl, optparse-generic
, process, QuickCheck, quickcheck-text, readline, rosezipper
, stdenv, tasty, tasty-hunit, tasty-quickcheck, temporary, text
, text-format, unordered-containers, vector, vty
, mkDerivation, fetchFromGitHub, lib
, ncurses, zlib, bzip2, solc
}:

lib.overrideDerivation (mkDerivation rec {
  pname = "hsevm";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "hsevm";
    rev = "v${version}";
    sha256 = "1c6zpphs03yfvyfbv1cjf04qh5q2miq7rpd7kx2cil77msi8hxw4";
  };

  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;

  postInstall = ''
    rm -rf $out/{lib,share}
  '';

  extraLibraries = [
    aeson ansi-wl-pprint base base16-bytestring base64-bytestring
    binary brick bytestring containers cryptonite data-dword deepseq
    directory filepath ghci-pretty lens lens-aeson memory mtl
    optparse-generic process QuickCheck quickcheck-text readline
    rosezipper temporary text text-format unordered-containers vector
    vty
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
})
