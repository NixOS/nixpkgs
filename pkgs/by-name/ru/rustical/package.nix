{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustical";
<<<<<<< HEAD
  version = "0.11.5";
=======
  version = "0.9.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-hvdYwh9nmSXS9QhyxW5mLRS4kgf164I+UxGHRlK1oH4=";
  };

  cargoHash = "sha256-rpTQpb0a8QhFT7Qo6hYZ+nPmWFnR/vSVCoHvZFQR3Cs=";
=======
    hash = "sha256-Q5dtkeKX9aqKHKKMTDU1sZkroRfG+kSq66Zj7idwEJg=";
  };

  cargoHash = "sha256-v4aUK1pbaZGuuQD36MPxAZYHJMnkhqvrKzlOdJTOV5g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Yet another calendar server aiming to be simple, fast and passwordless";
    homepage = "https://github.com/lennart-k/rustical";
    changelog = "https://github.com/lennart-k/rustical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "rustical";
  };
})
