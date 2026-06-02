{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ikill";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pjmp";
    repo = "ikill";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hOQBBwxkVnTkAZJi84qArwAo54fMC0zS+IeYMV04kUs=";
  };

  cargoHash = "sha256-Xbl9cQKWxtwNQqWW41mQrVAsvMLUkTb0irDLD/XstMI=";

  meta = {
    description = "Interactively kill running processes";
    homepage = "https://github.com/pjmp/ikill";
    maintainers = with lib.maintainers; [ zendo ];
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
    mainProgram = "ikill";
  };
})
