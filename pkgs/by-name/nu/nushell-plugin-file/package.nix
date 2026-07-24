{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_file";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "1bqli50sx7ldi1wvf6i622xq98y3h86lv989dsw8qvl0abbb4mm6";
  };

  cargoHash = "sha256-lGxwrkjQPK054cmMs0livc8g3MBlQex+m1XUBlDxjWs=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  meta = {
    description = "A file system plugin for Nushell";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ asakura ];
  };
})
