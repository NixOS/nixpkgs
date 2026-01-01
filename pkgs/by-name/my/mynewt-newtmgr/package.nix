{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  testers,
  mynewt-newtmgr,
}:

buildGoModule rec {
  pname = "mynewt-newtmgr";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-newtmgr";
    rev = "mynewt_${builtins.replaceStrings [ "." ] [ "_" ] version}_tag";
    sha256 = "sha256-fobaMkYLLK5qclogtClGdOjgTbmuse/72T3APNssYa4=";
  };

  vendorHash = "sha256-+vOZoueoMqlGnopLKc6pCgTmcgI34pxaMNbr6Y+JCfQ=";

  passthru.tests.version = testers.testVersion {
    package = mynewt-newtmgr;
    command = "newtmgr version";
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://mynewt.apache.org/";
    description = "Tool to communicate with devices running Mynewt OS";
    longDescription = ''
      Newt Manager (newtmgr) an application that enables a user to communicate
      with and manage remote devices running the Mynewt OS
    '';
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bezmuth ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ bezmuth ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
