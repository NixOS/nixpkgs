{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "licenseclassifier";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "licenseclassifier";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j+8hX8W0VD0h09Qmu7POnHT8f8+SeG5Si1fI0CDIwuo=";
  };

  # The new and improved "License Classifier v2" is hidden in a subdirectory.
  sourceRoot = "${finalAttrs.src.name}/v2";

  vendorHash = "sha256-u0VR8DCmbZS0MF26Y4HfqtLaGyX2n2INdAidVNbnXPE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "License Classifier";
    mainProgram = "identify_license";
    longDescription = ''
      The license classifier can analyze text to determine what type of license
      it contains. It searches for license texts in a file and compares them to
      an archive of known licenses. These files could be, e.g., LICENSE files
      with a single or multiple licenses in it, or source code files with the
      license text in a comment.
    '';
    homepage = "https://github.com/google/licenseclassifier";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tnias ];
  };
})
