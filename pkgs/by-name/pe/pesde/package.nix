{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage {
  pname = "pesde";
  version = "0.7.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pesde-pkg";
    repo = "pesde";
    rev = "e57b4c2db9eaf295c8af998212f427ea039ed46e";
    hash = "sha256-+8SneWw3UQwXg1IV1zn0OM1ySAJpcvMqyoQd7eYAarE=";
  };

  cargoHash = "sha256-1k7bmH4ocF9JK15C7YonCmwDKVh639Nropuzm62roDA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    dbus
  ];
  buildFeatures = [ "bin" ];

  meta = {
    description = "Package manager for the Luau programming language, supporting multiple runtimes including Roblox and Lune.";
    homepage = "https://github.com/pesde-pkg/pesde";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vokinn ];
    mainProgram = "pesde";
  };
}
