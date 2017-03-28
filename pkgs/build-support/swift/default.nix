{ stdenv, cacert, git, jq, swift }:

{ name, depsSha256
, src
, buildInputs ? []
, buildCfg ? "release" # (or "debug")
, ... } @ args:

let
  fetchDeps = import ./fetchswift.nix {
    inherit stdenv cacert git swift jq;
  };

  srcWithDeps = fetchDeps {
    inherit name src;
    sha256 = depsSha256;
  };

in stdenv.mkDerivation (args // {
  src = srcWithDeps;

  buildInputs = [ swift ] ++ buildInputs;

  buildPhase = args.buildPhase or ''
    echo "Running swift build -c ${buildCfg}"
    swift build -c ${buildCfg}
  '';

  # I think this will use debug confdiguration? Not sure
  checkPhase = args.checkPhase or ''
    echo "Running swift test"
    swift test
  '';

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    mkdir -p $out/bin
    for f in $(find .build/${buildCfg} -maxdepth 1 -type f -executable); do
      cp $f $out/bin
    done
  '';
})
