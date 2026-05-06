{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnglab";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    rev = "v${finalAttrs.version}";
    # darwin/linux hash mismatch
    postFetch = ''
      rm -rf "$out"/rawler/data/testdata/cameras/Canon/{"EOS REBEL T7i","EOS Rebel T7i"}
    '';
    hash = "sha256-uCOdfCeec//5CnkuDEIgCy9B7SsqiXN8oGkoHhJ4N5Y=";
  };

  cargoHash = "sha256-CFtCONFL1qRTg67AxfuEeIqLq/+57xMGbTKKMFPAhuo=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "dnglab";
  };
})
