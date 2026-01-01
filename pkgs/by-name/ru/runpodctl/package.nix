{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "runpodctl";
<<<<<<< HEAD
  version = "1.14.15";
=======
  version = "1.14.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-D1B5j1HYSXDgr1vW8kHzCohu3HiDljTEhQhzfa5q/Us=";
  };

  vendorHash = "sha256-/0kNURJHIRS1thqEe8d+SAsm8NPOEJa//g9tyswrvFg=";
=======
    hash = "sha256-BwXHwVdR3C/3SSxGbFfB79I3FKDbbiIzl592KqfESVc=";
  };

  vendorHash = "sha256-SaaHVaN2r3DhUk7sVizhRggYZRujd+e8qbpq0xOVD88=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  meta = {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
}
