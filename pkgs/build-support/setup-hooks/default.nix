{ makeSetupHook, writeScript }:

rec {

  makeWrapper = makeSetupHook { deps = [ dieHook ]; } ./make-wrapper.sh;

  ensureNewerSourcesHook = { year }: makeSetupHook {}
    (writeScript "ensure-newer-sources-hook.sh" ''
      postUnpackHooks+=(_ensureNewerSources)
      _ensureNewerSources() {
        find "$sourceRoot" '!' -newermt '${year}-01-01' \
          -exec touch -h -d '${year}-01-02' '{}' '+'
      }
    '');

  # Zip file format only allows times after year 1980, which makes
  # e.g. Python wheel building fail with: ValueError: ZIP does not
  # support timestamps before 1980
  ensureNewerSourcesForZipFilesHook = ensureNewerSourcesHook { year = "1980"; };

  dieHook = makeSetupHook {} ./die.sh;

  ld-is-cc-hook = makeSetupHook { name = "ld-is-cc-hook"; } ./ld-is-cc-hook.sh;

  setJavaClassPath = makeSetupHook { } ./set-java-classpath.sh;

  fixDarwinDylibNames = makeSetupHook { } ./fix-darwin-dylib-names.sh;

  keepBuildTree = makeSetupHook { } ./keep-build-tree.sh;

  enableGCOVInstrumentation = makeSetupHook { }
    ./enable-coverage-instrumentation.sh;

  findXMLCatalogs = makeSetupHook { } ./find-xml-catalogs.sh;

  separateDebugInfo = makeSetupHook { } ./separate-debug-info.sh;

  setupDebugInfoDirs = makeSetupHook { } ./setup-debug-info-dirs.sh;

  useOldCXXAbi = makeSetupHook { } ./use-old-cxx-abi.sh;

  pruneLibtoolFiles = makeSetupHook { name = "prune-libtool-files"; }
    ./prune-libtool-files.sh;

}
