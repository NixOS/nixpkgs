{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.37.1";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-LnfJmiV4SJpFBXDAJmwbHKv6RvO40e7/3Lm6Jc6YA40=";
  };

  cargoHash = "sha256-zNwlQ2CsDHQnFog59jKFAxVaNK0/8hUts6NRkFVKCGk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jraygauthier ];
    mainProgram = "geckodriver";
  };
})
