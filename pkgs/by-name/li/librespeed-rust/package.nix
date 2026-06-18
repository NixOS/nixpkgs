{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librespeed-rust";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jnm17GMjqh5evz3r0sd//dzKP3dKf0T1ReR1OAKq2Dw=";
  };

  cargoHash = "sha256-QE7NdnZXCEa2n1yI/ir/Lw8fFV9B6xU7EmrGhTXkOKY=";

  postInstall = ''
    cp -r assets $out/
  '';

  meta = {
    description = "Very lightweight speed test implementation in Rust";
    homepage = "https://github.com/librespeed/speedtest-rust";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "librespeed-rs";
  };
})
