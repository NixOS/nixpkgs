{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdfried";
<<<<<<< HEAD
  version = "0.15.0";
=======
  version = "0.14.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "benjajaja";
    repo = "mdfried";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-V++xkJBnTlqzcsw6BDkrqScIV+phzxyDqQXcV34L4ps=";
  };

  cargoHash = "sha256-qnsJkwAmBcakYcoqGdYRqfN6e46PG5IH6SAXLvy3mM8=";
=======
    hash = "sha256-Ys/CoyaIKVVRtQfmjc4XOABdrktZ1lIPNqw0V8jlY5I=";
  };

  cargoHash = "sha256-ipNhqxcc+Kfr6XtF3QtFh896YK5v1u4kXapiMUjC9n8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = true;

  meta = {
    description = "Markdown viewer TUI for the terminal, with big text and image rendering";
    homepage = "https://github.com/benjajaja/mdfried";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benjajaja ];
    platforms = lib.platforms.unix;
    mainProgram = "mdfried";
  };
})
