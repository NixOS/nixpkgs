{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "summon";
<<<<<<< HEAD
  version = "0.10.10";
=======
  version = "0.10.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zPzRsfNN75AZ1qsL/VZUkFxzt3blp8eQPXQsMmis3Cs=";
  };

  vendorHash = "sha256-xD9wv5XYjOWykG4sTrovJH+E6HrX0N7zxfrrFeF6j4Q=";
=======
    hash = "sha256-QzG8if3AkBei9uYbri7JS58iKmshyibRO12ye9RX8kk=";
  };

  vendorHash = "sha256-ZT3lVL8qoonmeWsmCzjMbOsAf2NvpheC6ThDzn4izkU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ quentini ];
=======
    maintainers = with maintainers; [ quentini ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
