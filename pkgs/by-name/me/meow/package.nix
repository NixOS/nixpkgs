{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "meow";
  version = "2.1.5";

  src = fetchCrate {
    inherit version;
    crateName = "${pname}-cli";
    sha256 = "sha256-6tf4/KRZj+1zlxnNgz3kw/HYR2QKg0kEwu+TbKah3e8=";
  };

  cargoHash = "sha256-Z3qAeIAiLJEHsqlDLvQXzX287dZSLhPg2V6clfI0Egs=";

  postInstall = ''
    mv $out/bin/meow-cli $out/bin/meow
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Print ASCII cats to your terminal";
    homepage = "https://github.com/PixelSergey/meow";
    license = lib.licenses.mit;
    mainProgram = "meow";
    maintainers = with lib.maintainers; [ pixelsergey ];
  };
}
