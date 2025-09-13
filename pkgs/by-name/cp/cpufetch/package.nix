{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "cpufetch";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "cpufetch";
    rev = "v${version}";
    sha256 = "sha256-sE3i2rw8W362BExFEImjw/t17qX8D4/0Ty8jG63bjbk=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -Dm755 cpufetch   $out/bin/cpufetch
    install -Dm644 LICENSE    $out/share/licenses/cpufetch/LICENSE
    installManPage cpufetch.1

    runHook postInstall
  '';

  meta = {
    description = "Simplistic yet fancy CPU architecture fetching tool";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/Dr-Noob/cpufetch";
    changelog = "https://github.com/Dr-Noob/cpufetch/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ devhell ];
    mainProgram = "cpufetch";
  };
}
