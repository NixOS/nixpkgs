{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    rev = "v${version}";
    # darwin/linux hash mismatch
    postFetch = ''
      rm -rf "$out"/rawler/data/testdata/cameras/Canon/{"EOS REBEL T7i","EOS Rebel T7i"}
    '';
    hash = "sha256-nUZZgVDnFH+TYx9eltI7edsAiWYPkvc3wwnkSNXr0Jw=";
  };

  cargoHash = "sha256-n7p16cCk1sJaTBQ/E7e4BmPeMvcApzTGBrd+CmJ8E3k=";

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
