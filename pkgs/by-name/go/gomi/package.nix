{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YsR2KU5Np6xQHkjM8KAoDp/XZ/9DkwBlMbu2IX5OQlk=";
  };

  vendorHash = "sha256-n31LUfdgbLQ/KmcFi8LdqmDHXgzbSCc+dnustGvc5SY=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
    mainProgram = "gomi";
  };
}
