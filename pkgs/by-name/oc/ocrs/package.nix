{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ocrs";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "robertknight";
    repo = pname;
    tag = "${pname}-v${version}";
    hash = "sha256-P+nOSlbcetxwEuuv64lmUEUB8fpBLUPd96+YBzD86u4=";
  };

  cargoHash = "sha256-NA7NR2iV83UxJGlpBg6Zy+fMwe3WP8VQKi89lWWoN5c=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Library and tool for OCR, extracting text from images";
    homepage = "https://github.com/robertknight/ocrs";
    mainProgram = pname;
    license = with licenses; [
      asl20
      mit
    ];

    maintainers = with maintainers; [
      multisn8
    ];
  };
}
