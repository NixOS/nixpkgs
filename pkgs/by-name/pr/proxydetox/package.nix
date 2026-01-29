{
  lib,
  rustPlatform,
  fetchFromGitHub,

  krb5,

  with-negotiate ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxydetox";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "kiron1";
    repo = "proxydetox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zC3ThkNStF1vdpXfHmnb/Hq3+kYig5Snt4APKhgkUyE=";
  };
  cargoHash = "sha256-7p7gpeeRt7X54A15RrNv91PBjuSDulX+7YHCT9uS0lk=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    krb5
  ];

  buildFeatures = lib.optional with-negotiate "negotiate";

  # To build libgssapi-sys
  env.LD_LIBRARY_PATH = lib.makeLibraryPath finalAttrs.buildInputs;

  meta = {
    description = "Http proxy with atomatic configuration and authentication";
    longDescription = ''
      A http proxy which can evaluate PAC files and forward to the correct
      parent proxy with authentication.
    '';
    homepage = "https://proxydetox.colorto.cc/";
    downloadPage = "https://github.com/kiron1/proxydetox/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/kiron1/proxydetox/commits/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux; # TODO: This could be used under darwin
    maintainers = with lib.maintainers; [ shved ];
    mainProgram = "proxydetox";
  };
})
