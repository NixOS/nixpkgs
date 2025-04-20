{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  bzip2,
  xz,
  zlib,
  zstd,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-rwoda/qDBQCSt2ZR40P4r4suohufp/rmjd+SenrC2Ag=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yukwNx0CwVJV5RIXCVxQdjUjgmd4YtKITzzR1NAKZiY=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    xz
    zlib
    zstd
  ];

  buildFeatures = [ "zstd/pkg-config" ];

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    substituteInPlace tests/ui.rs \
      --replace 'format!(r"/private{path}")' 'path.to_string()'
  '';

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  env.OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = with lib; {
    description = "Command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      psibi
    ];
    mainProgram = "ouch";
  };
}
