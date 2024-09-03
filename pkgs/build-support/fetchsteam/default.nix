{
  lib,
  runCommand,
  depotdownloader,
  cacert,
  writeText,
}:

{
  name ? "${toString app}-${toString depot}-${toString manifest}-depot",
  app,
  depot,
  manifest,
  branch ? null,
  language ? null,
  lowViolence ? false,
  fileList ? [ ],
  fileListRegex ? false,
  debug ? false,
  hash ? lib.fakeHash,
}:

runCommand name
  {
    nativeBuildInputs = [ depotdownloader ];

    env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    outputHash = hash;
    outputHashMode = "recursive";
  }
  ''
    # Hack to prevent DepotDownloader from crashing trying to write to ~/.local/share/
    export HOME=$(mktemp -d)

    DepotDownloader \
      -app "${toString app}" \
      -depot "${toString depot}" \
      -manifest "${toString manifest}" \
      ${lib.optionalString (branch != null) "-beta ${branch}"} \
      ${lib.optionalString (language != null) "-language ${language}"} \
      ${lib.optionalString lowViolence "-lowviolence"} \
      ${
        lib.optionalString (fileList != [ ]) (
          (lib.optionalString fileListRegex "regex:")
          + (writeText "steam-file-list-${name}.txt" (lib.concatStringsSep "\n" fileList))
        )
      } \
      ${lib.optionalString debug "-debug"} \
      -loginid ${
        # From DepotDownloader help:
        #   -loginid <#> - a unique 32-bit integer Steam LogonID in decimal, required if running multiple instances of DepotDownloader concurrently.
        # We are running multiple instances of DepotDownloader concurrently, so this is required.
        # Setting this to the manifest mod 2^32 will almost always result in a deterministic unique value.
        # Nix doesn't have a builtin for mod, so we have to do it manually.
        toString (manifest - (manifest / 4294967295) * 4294967295)
      } \
      -dir $out
    rm -rf $out/.DepotDownloader
  ''
