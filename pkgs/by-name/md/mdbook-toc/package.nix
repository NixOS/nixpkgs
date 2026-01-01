{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.15.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-toc";
    tag = version;
<<<<<<< HEAD
    sha256 = "sha256-gzwsPRhsAQTraiK/N5dKEj8NTpV/mYmECpS4KVl4Ql8=";
  };

  cargoHash = "sha256-+YvEptJlNjomIsyS7cNImwYa1SxawY05e5vq9VmrktA=";
=======
    sha256 = "sha256-FPbZH8cEYQ9wbSm6jA5/uiX8Wgx/FyuIJ/gPgSKUhBA=";
  };

  cargoHash = "sha256-haHJkyYAc4+ODJNEWiXzbl1xbJ7pyrtnPX/+ubjvX44=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
