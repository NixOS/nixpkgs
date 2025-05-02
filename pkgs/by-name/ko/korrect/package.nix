{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "korrect";
  version = "0.1.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-LS3pzDIb1G6lrP8lAG/Yd7Zcehjm5/TNEvTI+MnOomk=";
  };
  cargoHash = "sha256-vpjldD+aVVgCMQ/n+WZDPMMBRFPEeQZa09b45Q3m5UM=";

  # TODO updatescript
  meta = {
    description = "Kubectl version managing shim that invokes the correct kubectl version";
    homepage = "https://gitlab.com/cromulentbanana/korrect";
    license = lib.licenses.mit;
    # kubectl downloads don't work on x86_64-darwin yet, still investigating with upstream
    # https://gitlab.com/cromulentbanana/korrect/-/issues/14
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
    maintainers = [ lib.maintainers.dwt ];
  };
})
