{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudfox";
<<<<<<< HEAD
  version = "1.17.0";
=======
  version = "1.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AdfG0Vb4wUV8iShdaXSTwrKb8pa39ovwmvGTyfz1YDw=";
  };

  vendorHash = "sha256-mAYuquSkfYSUcTBPFJp+zwv5xCT5eqBmR7DDZjXx9YY=";
=======
    hash = "sha256-YLZSrBAEf0SXECAdnF2CQAlEd15DJ1Iv+x+RebM5tw4=";
  };

  vendorHash = "sha256-MQ1yoJjAWNx95Eafcarp/JNYq06xu9P05sF2QTW03NY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-w"
    "-s"
  ];

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudfox";
  };
}
