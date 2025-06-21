{
  lib,
  fetchFromGitHub,
  rustPlatform,
  icu,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  # msedit is preferred alternate naming according to upstream:
  # https://github.com/microsoft/edit?tab=readme-ov-file#package-naming
  pname = "msedit";
  version = "v1.2.0";

  # Upstream recommends nightly
  # https://github.com/microsoft/edit?tab=readme-ov-file#build-instructions
  RUSTC_BOOTSTRAP = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "edit";
    tag = finalAttrs.version;
    hash = "sha256-G5U5ervW1NAQY/fnwOWv1FNuKcP+HYcAW5w87XHqgA8=";
  };

  cargoHash = "sha256-ceAaaR+N03Dq2MHYel4sHDbbYUOr/ZrtwqJwhaUbC2o=";

  # Optional Dependency for find/replace support:
  # https://github.com/microsoft/edit?tab=readme-ov-file#icu-library-name-soname
  buildInputs = [
    icu
  ];

  postFixup = ''
    patchelf --add-rpath ${ icu }/lib $out/bin/*
  '';

  meta = {
    description = "A simple editor which pays homage to the classic MS-DOS Editor";
    homepage = "https://github.com/microsoft/edit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wrmilling ];
    mainProgram = "edit";
  };
})
