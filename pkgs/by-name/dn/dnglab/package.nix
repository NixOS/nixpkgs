{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    rev = "v${version}";
    # darwin/linux hash mismatch
    postFetch = ''
      rm -rf "$out"/rawler/data/testdata/cameras/Canon/{"EOS REBEL T7i","EOS Rebel T7i"}
    '';
    hash = "sha256-KBv7HhsGSPo1fa2QGXZi7zjh5Bu9wEtKwZ9X2TRkg2g=";
  };

  cargoHash = "sha256-0Fxhs6Igi5kf/I5wgQ6bM01ka3Favo4AhfIL2DSvLAw=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = with lib; {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "dnglab";
  };
}
