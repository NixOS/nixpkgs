{
  stdenv,
}:
{
  # If there's a need to patch external dependencies managed by Bazel
  # one option is to configure patches on Bazel level. Bazel doesn't
  # allow patches to be in absolute paths so this helper will produce
  # sources patch that adds given file to given location
  addFilePatch =
    {
      path,
      file,
    }:
    stdenv.mkDerivation {
      name = "add_file.patch";
      dontUnpack = true;
      buildPhase = ''
        mkdir -p $(dirname "${path}")
        cp ${file} "${path}"
        diff -u /dev/null "${path}" >result.patch || true  # diff exit code is non-zero if there's a diff
      '';
      installPhase = ''cp result.patch $out'';
    };
}
