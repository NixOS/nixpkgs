{
  lib,
  fetchFromGitHub,
  python3,
  runCommand,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "dfir_ntfs";
  version = "1.1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msuhanov";
    repo = "dfir_ntfs";
    tag = "${version}";
    hash = "sha256-iZd8qFLm77Fv8iUAB5M75u9a3SSBHqUEtZ8CPq8g7Ps=";
  };

  build-system = [ python3.pkgs.setuptools ];

  propagatedBuildInputs = [ python3.pkgs.llfuse ];

  passthru.tests.pytest =
    runCommand "dfir_ntfs-tests"
      {
        nativeBuildInputs = [ python3.pkgs.pytest ];
        inherit src;
      }
      ''
        unpackPhase
        cd source
        pytest -vv | tee result.log
        mkdir -p $out
        cp result.log $out/
      '';

  meta = {
    description = "NTFS/FAT parser for digital forensics & incident response";
    homepage = "https://github.com/msuhanov/dfir_ntfs";
    changelog = "https://github.com/msuhanov/dfir_ntfs/blob/${version}/ChangeLog";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.kyubai ];
  };
}
