{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  libiconv,
  Foundation,
  rustPlatform,
  rustc,
  setuptools-rust,
  range-typed-integers,
}:

buildPythonPackage rec {
  pname = "skytemple-rust";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-rust";
    rev = version;
    hash = "sha256-0hIwFJn/cwtKHKoD+upeorC52YnDlej3TrWf3PmAQAQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Gdypi9DJAXQgNaRCLEt4LTqUhBJC8plH0YhgNOIOGvA=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Foundation
  ];
  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  propagatedBuildInputs = [ range-typed-integers ];

  GETTEXT_SYSTEM = true;

  doCheck = false; # tests for this package are in skytemple-files package
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
