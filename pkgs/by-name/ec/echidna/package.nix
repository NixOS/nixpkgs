{
  lib,
  stdenv,
  makeWrapper,
  haskellPackages,
  fetchFromGitHub,
  # dependencies
  slither-analyzer,
}:

haskellPackages.mkDerivation rec {
  pname = "echidna";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    tag = "v${version}";
    sha256 = "sha256-5nzis7MXOqs0bhx2jrEexjZYZI2qY6D0D7AWO+SPs+A=";
  };

  isExecutable = true;

  buildTools = with haskellPackages; [
    hpack
  ];

  executableHaskellDepends = with haskellPackages; [
    # base dependencies
    aeson
    base
    containers
    directory
    hevm
    MonadRandom
    mtl
    text
    # library dependencies
    ansi-terminal
    async
    base16-bytestring
    binary
    brick
    bytestring
    data-bword
    data-dword
    deepseq
    exceptions
    extra
    filepath
    hashable
    html-conduit
    html-entities
    http-conduit
    ListLike
    optics
    optics-core
    process
    random
    rosezipper
    semver
    signal
    split
    strip-ansi-escape
    time
    unliftio
    utf8-string
    vector
    vty
    vty-crossplatform
    wai-extra
    warp
    word-wrap
    xml-conduit
    yaml
    # executable dependencies
    code-page
    filepath
    hashable
    optparse-applicative
    time
    with-utf8
  ];

  executableToolDepends = [
    makeWrapper
  ];

  preConfigure = ''
    hpack
  '';

  postInstall =
    with haskellPackages;
    # https://github.com/NixOS/nixpkgs/pull/304352
    lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      remove-references-to -t ${warp.out} "$out/bin/echidna"
      remove-references-to -t ${wreq.out} "$out/bin/echidna"
    ''
    # make slither-analyzer a runtime dependency
    + ''
      wrapProgram $out/bin/echidna \
        --prefix PATH : ${lib.makeBinPath [ slither-analyzer ]}
    '';

  doHaddock = false;

  # tests depend on a specific version of solc
  doCheck = false;

  homepage = "https://github.com/crytic/echidna";
  description = "Ethereum smart contract fuzzer";
  license = lib.licenses.agpl3Plus;
  maintainers = with lib.maintainers; [
    arturcygan
    hellwolf
  ];
  platforms = lib.platforms.unix;
  mainProgram = "echidna";
}
