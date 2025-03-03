{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-clean-recursive";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "IgaguriMK";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H/t9FW7zxS+58lrvay/lmb0xFgpeJQ1dCIm0oSEtflA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PcUKvVm9pKyw4sxJo9m6UJhsVURdlAwp1so199DAQBI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-clean-recursive \
      --prefix PATH : ${lib.makeBinPath [ cargo ]}
  '';

  meta = with lib; {
    description = "Cleans all projects under specified directory.";
    mainProgram = "cargo-clean-recursive";
    homepage = "https://github.com/IgaguriMK/cargo-clean-recursive";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ qubic ];
  };
}
