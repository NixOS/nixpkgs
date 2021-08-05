{ stdenv
, lib
, fetchurl
, fetchzip
, unzip
, autoPatchelfHook
, version ? "unstable-2021-06-15"
, sources ?
  let
    base = "https://chrome-infra-packages.appspot.com/dl/fuchsia/tools/jiri";
    x86_64 = "amd64";
    revision = "fcdfde57a8309823f6899264dd9c009a2e6fb01e";
    version = "unstable-2021-06-15";
  in
  {
    "${version}-x86_64-linux" = fetchurl {
      name= "git_revision-${revision}.zip";
      url = "${base}/linux-${x86_64}/+/git_revision:${revision}";
      sha256 = "11f35gni1dzb5lvdy1dcx9zk0m5jb2bb9jmq2c8kx2brrhcdlzdv";
    };
    "${version}-x86_64-darwin" = fetchurl {
      name= "git_revision-${revision}.zip";
      url = "${base}/mac-${x86_64}/+/git_revision:${revision}";
      sha256 = "c9dd2d345e91418a904094b4f0d64a0e872635c1aef6ed030c345632cf1cc626";
    };
  }
}:

assert version != null && version != "";
assert sources != null && (builtins.isAttrs sources);

stdenv.mkDerivation {
  pname = "jiri";
  inherit version;

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    chmod +x $out/jiri
  '';

  unpackPhase = ''
    mkdir -p $out
    unzip -d $out $src
  '';


  libPath = lib.makeLibraryPath [ stdenv.cc.cc ];

  dontStrip = true;

  meta = with lib; {
    homepage = "https://fuchsia.googlesource.com/jiri";
    maintainers = with maintainers; [ orthros ];
    description = "Jiri is a tool for multi-repo development.";
    longDescription = ''
      /jɪəri/ YEER-ee

      “Jiri integrates repositories intelligently”

      Jiri is a tool for multi-repo development. It supports:

        syncing multiple local GIT repos with upstream,
        capturing the current state of all local repos in a “snapshot”,
        restoring local project state from a snapshot, and
        facilitating sending change lists to Gerrit.
        Jiri has an extensible plugin model, making it easy to create new sub-commands.

        Jiri is open-source.
    '';
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
