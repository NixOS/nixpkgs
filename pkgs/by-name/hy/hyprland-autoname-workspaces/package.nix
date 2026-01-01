{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-autoname-workspaces";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprland-autoname-workspaces";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-2pRtbzG/kGxucigK/tctCQZttf/QYZoCMnUv+6Hpi7I=";
  };

  cargoHash = "sha256-91UxBjKSg/fAtiEqvyassIzeZYUc7SYbv5N+WF0vqGM=";

  doCheck = false;

  meta = {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = lib.platforms.linux;
=======
    hash = "sha256-M/3mqO7G2E5NW2uE+X8P4UhEl0r1fPXuxyb1NowJQnY=";
  };

  cargoHash = "sha256-GwLyC1G2RAIvb7c8vFRAUErp1ychY9mSAWhBNzX4Kvk=";

  doCheck = false;

  meta = with lib; {
    description = "Automatically rename workspaces with icons of started applications";
    homepage = "https://github.com/hyprland-community/hyprland-autoname-workspaces";
    license = licenses.isc;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprland-autoname-workspaces";
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
