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
  meta = with lib; {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with maintainers; [
      mkg
      cyplo
      cfouche
    ];
    license = with licenses; [ gpl1Plus ];
    mainProgram = "rename";
  };
}
