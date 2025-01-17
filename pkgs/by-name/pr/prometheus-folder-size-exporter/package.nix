{
  cargo,
  rustc,
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage {
  pname = "prometheus_folder_size_exporter";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_folder_size_exporter";
    rev = "5800b20e86855f407d9c5db48ad6f966a5bd2df2";
    hash = "sha256-lvn24NAKv4YU1iU0U7NBBQVr2BQM1wi5M6czj/7gUSk=";
  };

  cargoHash = "sha256-FuXlFQBcVGJkUqkJdiX37a9d4QpHYES04XVYusWrAJo=";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
  ];

  meta = with lib; {
    homepage = "https://github.com/MindFlavor/prometheus_folder_size_exporter";
    description = ''
      A Rust Prometheus exporter for folder size.
      This tool exports the folder size information (optionally including every subdir) in a format that Prometheus can understand.
    '';
    maintainers = with maintainers; [Silver-Golden];
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "prometheus_folder_size_exporter";
  };
}
