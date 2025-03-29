{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "landlock";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "Zouuup";
    repo = "landrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6xwE733N7mNSs8TfPOFFJkwdiOuqojL+XmDAOlDgMY=";
  };

  vendorHash = "sha256-Bs5b5w0mQj1MyT2ctJ7V38Dy60moB36+T8TFH38FA08=";

  meta = {
    description = "Lightweight, secure sandbox for running Linux processes using Landlock";
    changelog = "https://github.com/Zouuup/landrun/releases";
    homepage = "https://github.com/Zouuup/landrun";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    mainProgram = "landlock";
  };
})
