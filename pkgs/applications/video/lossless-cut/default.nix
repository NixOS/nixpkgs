{ stdenv
, fetchFromGitHub
, mkYarnPackage
, makeWrapper
, electron
}:
let
  name = "lossless-cut";
  version = "3.23.7";
in
mkYarnPackage {
  inherit version;
  src = fetchFromGitHub {
    owner = "mifi";
    repo = name;
    rev = "v${version}";
    sha256 = "14vfmidj0m11vd1asghmcxwj102c468n6wb4swagnjzrxqh22xa3";
  };

  nativeBuildInputs = [ makeWrapper ];
  runtimeDependencies = [ electron ];

  installPhase = ''
    # resources
    electronFileDir=$out/libexec/lossless-cut
    mkdir -p $electronFileDir
    mv ./deps/lossless-cut $electronFileDir
    mv ./node_modules $electronFileDir

    # executable
    mkdir -p $out/bin
    makeWrapper "${electron}/bin/electron" "$out/bin/lossless-cut" --add-flags "$electronFileDir"
  '';

  # Doesn't need to generate the tarball
  distPhase = ''
    true
  '';

  meta = with stdenv.lib; {
    description = "The swiss army knife of lossless video/audio editing";
    license = licenses.mit;
    homepage = "https://mifi.no/losslesscut";
    maintainers = with maintainers; [ ShamrockLee ];
    platforms = platforms.all;
  };
}
