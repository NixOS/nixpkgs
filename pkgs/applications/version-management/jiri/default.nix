{ stdenv
, lib
, fetchurl
, fetchzip
, unzip
, autoPatchelfHook
}:

stdenv.mkDerivation {
  pname = "jiri";
  version = "unstable-2022-07-26";

  src =
    let
      base = "https://chrome-infra-packages.appspot.com/dl/fuchsia/tools/jiri";
      x86_64 = "amd64";
      revision = "398e3ee5d9e738eee58ea6ef3bf7d43fbe8c3f12";
    in
    {
      "x86_64-linux" = fetchurl {
        name = "git_revision-${revision}.zip";
        url = "${base}/linux-${x86_64}/+/git_revision:${revision}";
        sha256 = "0bzixfrvbyfzy7ps0avkdclg5r69r7jrq4jl3knrflb96qjw2gvi";
      };
      "x86_64-darwin" = fetchurl {
        name = "git_revision-${revision}.zip";
        url = "${base}/mac-${x86_64}/+/git_revision:${revision}";
        sha256 = "157iard65cwmdj600zsq5l2q17mdx4clylc41p1i0ryd656fr37x";
      };
    }."${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp jiri $out/bin/
    cp -r .cipdpkg $out/bin/
    chmod +x $out/bin/jiri
  '';

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

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
