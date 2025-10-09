{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "psudohash";
  version = "1.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "t3l3machus";
    repo = "psudohash";
    tag = "v${version}";
    hash = "sha256-I/vHQraGmIWmx/v+szL5ZQJpjkSBaCpEx0r4Mc6FgKA=";
  };

  dependencies = with python3Packages; [
    tqdm
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 psudohash.py $out/bin/psudohash

    install -Dm444 common_padding_values.txt $out/share/psudohash/common_padding_values.txt

    substituteInPlace $out/bin/psudohash \
      --replace "common_padding_values.txt" "$out/share/${pname}/common_padding_values.txt"

    runHook postInstall
  '';

  meta = {
    description = "Password list generator for orchestrating brute force attacks and cracking hashes";
    homepage = "https://github.com/t3l3machus/psudohash";
    changelog = "https://github.com/t3l3machus/psudohash/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ exploitoverload ];
    mainProgram = "psudohash";
  };
}
