{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-clean-recursive";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "IgaguriMK";
    repo = "cargo-clean-recursive";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-H/t9FW7zxS+58lrvay/lmb0xFgpeJQ1dCIm0oSEtflA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PcUKvVm9pKyw4sxJo9m6UJhsVURdlAwp1so199DAQBI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-clean-recursive \
      --prefix PATH : ${lib.makeBinPath [ cargo ]}
  '';

  meta = {
    description = "Cleans all projects under specified directory.";
    mainProgram = "cargo-clean-recursive";
    homepage = "https://github.com/IgaguriMK/cargo-clean-recursive";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ qubic ];
  };
})
