{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "equ";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "cznic";
    repo = "equ";
    rev = "v${version}";
    hash = "sha256-o69FwmYGv+ngXxXaxIkKc5OcV+/fAYwyZ+WZenZ4C4I=";
  };

  vendorHash = "sha256-mUJaYOgO2QoJ/Gm0tmKWUhIrYm/4wHlyb0H8rI/goHA=";

  meta = {
    description = "Plain TeX math editor";
    homepage = "https://gitlab.com/cznic/equ";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "equ";
  };
}
