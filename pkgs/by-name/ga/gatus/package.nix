{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
<<<<<<< HEAD
  version = "5.33.1";
=======
  version = "5.31.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-m7dOgxk1EuyqIuVK4ZDimqZX015Osk5FF+0/SFAkp90=";
  };

  vendorHash = "sha256-T4BPCDYR/f2rInLNytaVibE2hKWsIYqpJw9asY0TbvY=";
=======
    hash = "sha256-thLS6pAlnu7XcQHritr28CnzmpIOgIcEPIch2IwhZfQ=";
  };

  vendorHash = "sha256-VaD/cTf9D00gr6+9gKadK4aTwqhmJN/+cohwNvckxyw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

<<<<<<< HEAD
  meta = {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ undefined-moe ];
=======
  meta = with lib; {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ undefined-moe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gatus";
  };
}
