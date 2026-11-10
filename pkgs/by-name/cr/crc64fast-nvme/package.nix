{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crc64fast-nvme";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "awesomized";
    repo = "crc64fast-nvme";
    tag = finalAttrs.version;
    hash = "sha256-BEFdVspQU2exj6ndULCs0TfH7aIx/NvfUkTSL32bIPk=";
  };

  postPatch = ''
    cp -L ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postInstall = ''
    mv $out/bin/build_table $out/bin/pclmulqdq_build_table
    install -Dm644 crc64fast_nvme.h -t $out/include/
  '';

  meta = {
    description = "SIMD accelerated carryless-multiplication CRC-64/NVME checksum computation (based on Intel's PCLMULQDQ paper)";
    homepage = "https://github.com/awesomized/crc64fast-nvme";
    mainProgram = "crc_64_nvme_checksum";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ powwu ];
  };
})
