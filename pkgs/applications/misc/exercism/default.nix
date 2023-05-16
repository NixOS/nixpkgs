{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "exercism";
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "exercism";
    repo  = "cli";
<<<<<<< HEAD
    rev   = "refs/tags/v${version}";
    hash  = "sha256-+DXmbbs9oo667o5P0OVcfBMMIvyBzEAdbrq9i+U7p0k=";
  };

  vendorHash = "sha256-wQGnGshsRJLe3niHDoyr3BTxbwrV3L66EjJ8x633uHY=";
=======
    rev   = "v${version}";
    hash  = "sha256-9GdkQaxYvxMGI5aFwUtQnctjpZfjZaKP3CsMjC/ZBSo=";
  };

  vendorHash = "sha256-EW9SNUqJHgPQlNpeErYaooJRXGcDrNpXLhMYpmZPVSw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
  };
}
