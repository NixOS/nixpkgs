{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "jf";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "jf";
    rev = "v${version}";
    hash = "sha256-A29OvGdG6PyeKMf5RarEOrfnNSmXhXri0AlECHWep6M=";
  };

  cargoHash = "sha256-NU5D7VMQtlOFzr+LqODvDzVw56wFClcBxKo1h8zfgfY=";

  nativeBuildInputs = [ installShellFiles ];

  # skip auto manpage update
  buildNoDefaultFeatures = true;

  postInstall = ''
    installManPage assets/jf.1
  '';

  meta = with lib; {
    description = "Small utility to safely format and print JSON objects in the commandline";
    mainProgram = "jf";
    homepage = "https://github.com/sayanarijit/jf";
    license = licenses.mit;
    maintainers = [ maintainers.sayanarijit ];
  };
}
