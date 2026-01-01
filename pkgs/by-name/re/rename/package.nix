{
  lib,
  fetchFromGitHub,
  perlPackages,
}:

perlPackages.buildPerlPackage rec {
  pname = "rename";
  version = "1.16.3";
  outputs = [ "out" ];
  src = fetchFromGitHub {
    owner = "pstray";
    repo = "rename";
    rev = "v${version}";
    sha256 = "KQsBO94fsa4CbTHNyJxOD96AwUfKNLa9p44odlNgQao=";
  };
<<<<<<< HEAD
  meta = {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mkg
      cyplo
      cfouche
    ];
<<<<<<< HEAD
    license = with lib.licenses; [ gpl1Plus ];
=======
    license = with licenses; [ gpl1Plus ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rename";
  };
}
