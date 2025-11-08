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
  withSMB = false;
  withMagic = true;
  nameSuffix = "-most";
  longDescription = "Almost-full variant, all dependencies and features except those marked buggy";
}
