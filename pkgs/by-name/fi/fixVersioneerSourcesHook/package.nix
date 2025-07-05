{
  lib,
  makeSetupHook,
  fetchFromGitHub,
  fetchzip,
  fixVersioneerSourcesHook,
  runCommand,
}:
makeSetupHook {
  name = "fixVersioneerSourcesHook";

  passthru.tests.test =
    let
      # An example of a project that uses versioneer
      src = fetchFromGitHub {
        owner = "jcrist";
        repo = "msgspec";
        tag = "0.19.0";
        hash = "sha256-CajdPNAkssriY/sie5gR+4k31b3Wd7WzqcsFmrlSoPY=";
      };
      # Make a clean tarball out of the source to be fetched by fetchzip later
      srcClean = runCommand "source-clean.tar.gz" { } ''
        tar -cf $out -C ${src} .
      '';
      # Patch tarball adding a common error produced in GitHub source archives
      srcDirty = runCommand "source-dirty.tar.gz" { } ''
        unpackFile ${src}
        chmod -R u+w source
        cd source
        sed -i 's/git_refnames = " (\(.*\))"/git_refnames = " (HEAD -> main, \1)"/' msgspec/_version.py
        tar -cf $out .
      '';
      # Make the result of fetchzip not fixed output to run it with and without hook
      doFetch =
        name: src: withHook:
        (fetchzip {
          inherit name;
          url = "file://${src}";
          stripRoot = false;
          nativeBuildInputs = lib.optionals withHook [ fixVersioneerSourcesHook ];
        }).overrideAttrs
          {
            outputHashAlgo = null;
            outputHash = null;
          };
    in
    # Now verify that all these produce the result equal to the clean one
    runCommand "test-fixVersioneerSourcesHook"
      {
        clean = doFetch "clean" srcClean false;
        cleanWithHook = doFetch "cleanWithHook" srcClean true;
        dirtyWithHook = doFetch "dirtyWithHook" srcDirty true;
      }
      ''
        diff -ru $clean $cleanWithHook
        diff -ru $clean $dirtyWithHook
        touch $out
      '';
} ./setup-hook.sh
