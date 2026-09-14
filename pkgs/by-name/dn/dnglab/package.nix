{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnglab";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    rev = "v${finalAttrs.version}";
    # darwin/linux hash mismatch
    postFetch = ''
      rm -rf "$out"/rawler/data/testdata/cameras/Canon/{"EOS REBEL T7i","EOS Rebel T7i"}
    '';
    hash = "sha256-2I7VOJdeJP4NjSosUpRFyPGtbREDkJvJPXbXWImCgpQ=";
  };

  cargoHash = "sha256-BDhfxsd//SJvkiGjaFlZCPLCHFNV55GlzqAN1LDQQfE=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
    mainProgram = "dnglab";
  };
})
