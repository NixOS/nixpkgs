{ copyparty }:
copyparty.override {
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
}
