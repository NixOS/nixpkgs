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
  meta = {
    description = "Rename files according to a Perl rewrite expression";
    homepage = "https://github.com/pstray/rename";
    maintainers = with lib.maintainers; [
      mkg
      cyplo
      cfouche
    ];
    license = with lib.licenses; [ gpl1Plus ];
    mainProgram = "rename";
  };
}
