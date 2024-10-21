{ lib
, python3Packages
, fetchFromGitHub
, makeWrapper
}:

python3Packages.buildPythonApplication rec {
  pname = "flatpak-pip-generator";
  version = "unstable-2023-11-27";
  pyproject = false;

  flatpak-builder-tools = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-builder-tools";
    rev = "f0614ca5871ed0588961235fb942bb64f6e29575";
    hash = "sha256-AAebCrt8pGA9EidNupsMBFgKcS8qAdFS2Uvvp0IE6rM=";
  };
  src = "${flatpak-builder-tools}/pip";

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3Packages; [
    requirements-parser
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp flatpak-pip-generator $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically generates flatpak-builder manifest from a pip package name";
    licenses = with licenses; [ mit ];
    homepage = "https://github.com/flatpak/flatpak-builder-tools/tree/master/pip";
    maintainers = with maintainers; [ annaaurora ];
  };
}
