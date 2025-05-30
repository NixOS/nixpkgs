{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "nom";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    tag = "v${version}";
    hash = "sha256-PqoTpy+Pz5OS+7pzzdxNKeqIZRipOvHKMs9o67XzdqY=";
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
