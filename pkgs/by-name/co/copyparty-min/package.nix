{ copyparty }:
(copyparty.override {
  withHashedPasswords = false;
  withCertgen = false;
  withThumbnails = false;
  withFastThumbnails = false;
  withMediaProcessing = false;
  withBasicAudioMetadata = false;
  withZeroMQ = false;
  withFTP = false;
  withFTPS = false;
  withTFTP = false;
  withSMB = false;
  withMagic = false;
  nameSuffix = "-min";
  longDescription = "Minimal variant, minimal dependencies and fewest features";
}).overrideAttrs
  (old: {
    # don't try to update this package, just update `copyparty`
    # nixpkgs-update: no auto update
    passthru = old.passthru // {
      updateScript = null;
    };

    meta = old.meta // {
      # this serves two purposes: it changes the description, but also makes meta.position point to this file so that the 'no auto update' works
      description = old.meta.description + " - minimal variant";
    };
  })
