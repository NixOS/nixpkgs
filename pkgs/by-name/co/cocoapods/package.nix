{
  lib,
  bundlerApp,
  ruby,
  beta ? false,
}:

bundlerApp {
  inherit ruby;
  pname = "cocoapods";
  gemfile = if beta then ./Gemfile-beta else ./Gemfile;
  lockfile = if beta then ./Gemfile-beta.lock else ./Gemfile.lock;
  gemset = if beta then ./gemset-beta.nix else ./gemset.nix;
  exes = [ "pod" ];

  # toString prevents the update script from being copied into the nix store
  passthru.updateScript = toString ./update;

<<<<<<< HEAD
  meta = {
    description = "Manages dependencies for your Xcode projects";
    homepage = "https://github.com/CocoaPods/CocoaPods";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Manages dependencies for your Xcode projects";
    homepage = "https://github.com/CocoaPods/CocoaPods";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [
      peterromfeldhk
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pod";
  };
}
