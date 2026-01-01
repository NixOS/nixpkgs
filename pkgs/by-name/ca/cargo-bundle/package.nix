{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  libxkbcommon,
  wayland,
<<<<<<< HEAD
  openssl,
  squashfsTools,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bundle";
  version = "0.9.0";
=======
}:

rustPlatform.buildRustPackage {
  pname = "cargo-bundle";
  # the latest stable release fails to build on darwin
  version = "unstable-2023-08-18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Ulah5NtjQh5dIB/nhTrDstnaub4LS9iH33E1iv1JpY=";
  };

  cargoHash = "sha256-qE0ZDq0UJHfsivvI1W44u/pVjKMDGrghSl7sfau/pIY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
=======
    rev = "c9f7a182d233f0dc4ad84e10b1ffa0d44522ea43";
    hash = "sha256-n+c83pmCvFdNRAlcadmcZvYj+IRqUYeE8CJVWWYbWDQ=";
  };

  cargoHash = "sha256-g898Oelrk/ok52raTEDhgtQ9psc0PFHd/uNnk1QeXCs=";

  nativeBuildInputs = [
    pkg-config
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
<<<<<<< HEAD
    openssl
  ];

  postFixup = ''
    wrapProgram $out/bin/cargo-bundle \
      --prefix PATH : ${lib.makeBinPath [ squashfsTools ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrap rust executables in OS-specific app bundles";
    mainProgram = "cargo-bundle";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
  ];

  meta = with lib; {
    description = "Wrap rust executables in OS-specific app bundles";
    mainProgram = "cargo-bundle";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
