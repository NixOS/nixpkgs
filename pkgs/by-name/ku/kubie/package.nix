{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.25.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-+sSooE0KJqvWFdR63qazOMmSS8dV7MirYZ+sk7BnGQ4=";
  };

  buildNoDefaultFeatures = true;
  useFetchCargoVendor = true;
  cargoHash = "sha256-Yf8fAW65K7SLaRpvegjWBLVDV33sMGV+I1rqlWvx5Ss=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    mainProgram = "kubie";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
