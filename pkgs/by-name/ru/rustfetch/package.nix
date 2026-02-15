{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "rustfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lemuray";
    repo = "rustfetch";
    rev = "v${version}";
    hash = "sha256-iGcxDKl36kbEi+OiH4gB2+HxP37bpqAMZguIXDzq3Jw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    # The source contains the binary already (from the GitHub release)
    # Find and install the binary
    find . -name "${pname}" -type f -executable -exec cp {} $out/bin/ \;

    runHook postInstall
  '';

  meta = {
    description = "Rustfetch is a CLI tool designed to fetch system information in the fastest and safest way possible while still keeping it visually appealing, inspired by neofetch and fastfetch.";
    homepage = "https://github.com/lemuray/rustfetch";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      LeFaucheur0769
    ];
    mainProgram = "rustfetch";
  };
}
