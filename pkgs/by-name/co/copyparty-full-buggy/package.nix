{ copyparty }:
<<<<<<< HEAD
(copyparty.override {
=======
copyparty.override {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  withMagic = true;
  withSMB = true;
  nameSuffix = "-full-buggy";
  longDescription = "Full variant, all dependencies and features including those marked buggy";
<<<<<<< HEAD
}).overrideAttrs
  (old: {
    # don't try to update this package, just update `copyparty`
    # nixpkgs-update: no auto update
    passthru = old.passthru // {
      updateScript = null;
    };

    meta = old.meta // {
      # this serves two purposes: it changes the description, but also makes meta.position point to this file so that the 'no auto update' works
      description = old.meta.description + " - full variant";
    };
  })
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
