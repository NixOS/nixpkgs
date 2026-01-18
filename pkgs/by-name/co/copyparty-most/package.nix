{ copyparty }:
(copyparty.override {
  withHashedPasswords = true;
  withCertgen = true;
  withThumbnails = true;
  withFastThumbnails = true;
  withMediaProcessing = true;
  withBasicAudioMetadata = true;
  withZeroMQ = true;
  withFTP = true;
  withFTPS = true;
  withTFTP = true;
  withSMB = false;
  withMagic = true;
  nameSuffix = "-most";
  longDescription = "Almost-full variant, all dependencies and features except those marked buggy";
}).overrideAttrs
  (old: {
    # don't try to update this package, just update `copyparty`
    # nixpkgs-update: no auto update
    passthru = old.passthru // {
      updateScript = null;
    };

    meta = old.meta // {
      # this serves two purposes: it changes the description, but also makes meta.position point to this file so that the 'no auto update' works
      description = old.meta.description + " - most variant";
    };
  })
