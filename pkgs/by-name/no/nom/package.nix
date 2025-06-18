{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "nom";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    tag = "v${version}";
    hash = "sha256-F1lKBfDufotQjVNJ1yMosRl1UlGMBlYCTHXdCzeVflg=";
  };

  vendorHash = "sha256-d5KTDZKfuzv84oMgmsjJoXGO5XYLVKxOB5XehqgRvYw=";

  meta = with lib; {
    homepage = "https://github.com/guyfedwards/nom";
    description = "RSS reader for the terminal";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      nadir-ishiguro
      matthiasbeyer
    ];
    mainProgram = "nom";
  };
}
