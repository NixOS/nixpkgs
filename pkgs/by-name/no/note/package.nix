{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  name = "note";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "note";
    rev = "e1876e4c7aec769ea3b3296d7df25175ba899652";
    hash = "sha256-mdQjtXRxh5oCz0ThsnnsujcO97yu0K8TaX6jefOpR6g=";
  };

  vendorHash = "sha256-kzMvksDjhqKlHvBwl0spOApFKHKM7lm0WG2hifP6+Ro=";

  meta = with lib; {
    description = "A tool for taking temporary notes";
    homepage = "https://github.com/NewDawn0/note";
    maintainers = with maintainers; [NewDawn0];
    license = licenses.mit;
  };
}
