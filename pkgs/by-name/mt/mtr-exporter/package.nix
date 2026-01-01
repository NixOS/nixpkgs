{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mtr-exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mgumz";
    repo = "mtr-exporter";
    rev = version;
    hash = "sha256-GkTkL72ZdxeCMG24rjGx8vWt5GQqrTXNxTDpQ81ite8=";
  };

  vendorHash = null;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Mtr-exporter periodically executes mtr to a given host and
      provides the measured results as prometheus metrics.
    '';
    homepage = "https://github.com/mgumz/mtr-exporter";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jakubgs ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mtr-exporter";
  };
}
