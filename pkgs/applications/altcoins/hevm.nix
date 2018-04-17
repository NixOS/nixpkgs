{ mkDerivation, abstract-par, aeson, ansi-wl-pprint, async, base
, base16-bytestring, base64-bytestring, binary, brick, bytestring
, cereal, containers, cryptonite, data-dword, deepseq, directory
, filepath, ghci-pretty, here, HUnit, lens
, lens-aeson, memory, monad-par, mtl, optparse-generic, process
, QuickCheck, quickcheck-text, readline, rosezipper, scientific
, stdenv, tasty, tasty-hunit, tasty-quickcheck, temporary, text
, text-format, time, unordered-containers, vector, vty

, restless-git

, fetchFromGitHub, lib, makeWrapper
, ncurses, zlib, bzip2, solc, coreutils
, bash
}:

lib.overrideDerivation (mkDerivation rec {
  pname = "hevm";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "hevm";
    rev = "v${version}";
    sha256 = "1a27bh0azf2hdg5hp6s9azv2rhzy7vrlq1kmg688g9nfwwwhgkp0";
  };

  isLibrary = false;
  isExecutable = true;
  enableSharedExecutables = false;

  postInstall = ''
    wrapProgram $out/bin/hevm \
       --add-flags '+RTS -N$((`${coreutils}/bin/nproc` - 1)) -RTS' \
       --suffix PATH : "${lib.makeBinPath [bash coreutils]}"
  '';

  extraLibraries = [
    abstract-par aeson ansi-wl-pprint base base16-bytestring
    base64-bytestring binary brick bytestring cereal containers
    cryptonite data-dword deepseq directory filepath ghci-pretty lens
    lens-aeson memory monad-par mtl optparse-generic process QuickCheck
    quickcheck-text readline rosezipper scientific temporary text text-format
    unordered-containers vector vty restless-git
  ];
  executableHaskellDepends = [
    async readline zlib bzip2
  ];
  testHaskellDepends = [
    base binary bytestring ghci-pretty here HUnit lens mtl QuickCheck
    tasty tasty-hunit tasty-quickcheck text vector
  ];

  homepage = https://github.com/dapphub/hevm;
  description = "Ethereum virtual machine evaluator";
  license = stdenv.lib.licenses.agpl3;
  maintainers = [stdenv.lib.maintainers.dbrock];
  broken = true; # 2018-04-10
}) (attrs: {
  buildInputs = attrs.buildInputs ++ [solc];
  nativeBuildInputs = attrs.nativeBuildInputs ++ [makeWrapper];
})
