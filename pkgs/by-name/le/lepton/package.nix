{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  glibc,
}:

stdenv.mkDerivation {
  version = "2019-08-20";
  pname = "lepton-unstable";

  src = fetchFromGitHub {
    repo = "lepton";
    owner = "dropbox";
    rev = "3d1bc19da9f13a6e817938afd0f61a81110be4da";
    sha256 = "0aqs6nvcbq8cbfv8699fa634bsz7csmk0169n069yvv17d1c07fd";
  };

  nativeBuildInputs = [
    cmake
    git
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ glibc.static ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/dropbox/lepton";
    description = "Tool to losslessly compress JPEGs";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/dropbox/lepton";
    description = "Tool to losslessly compress JPEGs";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ artemist ];
=======
    maintainers = with maintainers; [ artemist ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    knownVulnerabilities = [ "CVE-2022-4104" ];
  };
}
