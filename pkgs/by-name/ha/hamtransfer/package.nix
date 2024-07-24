{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, sqlite
}:

rustPlatform.buildRustPackage {
  pname = "hamtransfer";
  version = "unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "hamtransfer";
    rev = "6b0ac28e0b8cdcc3ac9aba9cd6115e48c4f26c1e";
    hash = "sha256-yZwbFjs+mnTbU+75dwRhVjvXXoHQuzgE9GlliUQZV1s=";
  };

  cargoHash = "sha256-lFzsURGhEcuTL6dHt4/l54eT3mD7H8tsW/+unisdjKY=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    sqlite
  ];

  postInstall = ''
    mv $out/bin/downloader $out/bin/hamtransfer-downloader
    mv $out/bin/uploader $out/bin/hamtransfer-uploader
  '';

  meta = with lib; {
    description = "Tool for transferring files over amateur radio using modern techniques";
    homepage = "https://github.com/ThomasHabets/hamtransfer";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthewcroughan sarcasticadmin pkharvey ];
  };
}
