{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "iwe";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${version}";
    hash = "sha256-eE84KzYJTJ39UDQt3VZpSIba/P+7VFR9K6+MSMlg0Wc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K8RxVYHh0pStQyHMiLLeUakAoK1IMoUtCNg70/NfDiI=";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r target/release/iwe target/release/iwes $out/bin
    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd iwe --cmd iwes
  '';

  meta = with lib; {
    description = "IWE - Markdown notes assistant";
    homepage = "https://iwe.md/";
    maintainers = [
    ];
    license = with licenses; [
      asl20
    ];
    mainProgram = "iwe";
  };
}
