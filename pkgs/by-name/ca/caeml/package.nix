{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "caeml";
  version = "0-unstable-2023-05-24";

  src = fetchFromGitHub {
    owner = "ferdinandyb";
    repo = "caeml";
    rev = "25dbe10e99aac9b0ce3b80787c162628104f5cd2";
    sha256 = "UIQCNkUyrtMF0IiAfkDvE8siqxNvfFc9TZdlZiTxCVc=";
  };

  vendorHash = "sha256-SDJsRLIGlLv/6NUctCrn6z1IDEmum1Wn5I8RFuwcOe8=";

  meta = with lib; {
    description = "cat eml files";
    mainProgram = "caeml";
    longDescription = ''
      Reads an email file from either STDIN or from a file passed as the first
      argument, digests it and outputs it to STDOUT in a more human readable
      format. This means only From, To, Cc, Bcc, Date and Subject headers are
      kept and these are decoded and of all the parts only text/plain is returned.
    '';
    homepage = "https://github.com/ferdinandyb/caeml";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
  };
}
