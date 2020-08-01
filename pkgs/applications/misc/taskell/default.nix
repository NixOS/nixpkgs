{ lib, haskellPackages, fetchFromGitHub }:

let
  version = "1.9.4";
  sha256  = "0k8s1f0c99fz6jmqi6jqscsfxrrijnnpyw4jcj8zxpdf0sc07gca";

in (haskellPackages.mkDerivation {
  pname = "taskell";
  inherit version;

  src = fetchFromGitHub {
    owner = "smallhadroncollider";
    repo = "taskell";
    rev = version;
    inherit sha256;
  };

  postPatch = ''${haskellPackages.hpack}/bin/hpack'';

  # basically justStaticExecutables; TODO: use justStaticExecutables
  enableSharedExecutables = false;
  enableLibraryProfiling = false;
  isExecutable = true;
  doHaddock = false;
  postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";

  # copied from packages.yaml
  libraryHaskellDepends = with haskellPackages; [
    classy-prelude
    # base <=5
    aeson
    brick
    # bytestring
    config-ini
    # containers
    # directory
    file-embed
    fold-debounce
    http-conduit
    http-client
    http-types
    lens
    raw-strings-qq
    # mtl
    # template-haskell
    # text
    time
    vty
    tz
  ];

  executableHaskellDepends = [];

  testHaskellDepends = with haskellPackages; [
    tasty
    tasty-discover
    tasty-expected-failure
    tasty-hunit
  ];

  description = "Command-line Kanban board/task manager with support for Trello boards and GitHub projects";
  homepage    = "https://taskell.app";
  license     = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ matthiasbeyer ];
  platforms = [ "x86_64-linux" ];
})
