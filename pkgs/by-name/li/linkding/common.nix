{ lib, fetchFromGitHub }:
let
  version = "v1.25.0";
in
{
  inherit version;

  npmDepsHash = "sha256-s+ZbAL+t+ABvrA3XXPSjlNmRZrwlWI4x9La2YByBI90=";

  src = fetchFromGitHub {
    owner = "sissbruecker";
    repo = "linkding";
    rev = version;
    sha256 = "sha256-2zSYA1eem6ZqybdcwNC8g8wGQlqVhZipnrUxnOFryo4=";
  };

  meta = with lib; {
    homepage = "https://github.com/sissbruecker/linkding";
    license = licenses.mit;
    maintainers = with maintainers; [ rogryza ];
  };
}
