{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomatrix";
  version = "101.0.0";

  src = fetchFromGitHub {
    owner = "GeertJohan";
    repo = "gomatrix";
    rev = "v${version}";
    hash = "sha256-VeRHVR8InfU+vEw2F/w3KFbNVSKS8ziRlQ98f3cuBfM=";
  };

  vendorHash = "sha256-yQSsxiWkihpoYBH9L6by/D2alqECoUEG4ei5T+B9gPs=";

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = ''Displays "The Matrix" in a terminal'';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ skykanin ];
=======
  meta = with lib; {
    description = ''Displays "The Matrix" in a terminal'';
    license = licenses.bsd2;
    maintainers = with maintainers; [ skykanin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/GeertJohan/gomatrix";
    mainProgram = "gomatrix";
  };
}
