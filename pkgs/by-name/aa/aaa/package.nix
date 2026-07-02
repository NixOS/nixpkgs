{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aaa";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "asciimoth";
    repo = "aaa";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-z8PXkX6Bh3oD8tRf+tsLJHbx5wIz2mBYhJSEL88hBDc=";
  };

  cargoHash = "sha256-dt3nbVS8i075O8m9x+FsDi3VeihVKVIV0wnPqyYUaIk=";

  meta = {
    description = "Swiss Army knife for animated ascii art";
    homepage = "https://github.com/asciimoth/aaa";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ asciimoth ];
    mainProgram = "aaa";
  };
})
