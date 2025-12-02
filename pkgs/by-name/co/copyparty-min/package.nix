{ copyparty }:
copyparty.override {
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
}
