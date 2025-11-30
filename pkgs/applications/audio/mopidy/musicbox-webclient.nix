{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-musicbox-webclient";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    tag = "v${version}";
    sha256 = "1lzarazq67gciyn6r8cdms0f7j0ayyfwhpf28z93ydb280mfrrb9";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
  ];

  doCheck = false;

  meta = {
    description = "Mopidy frontend extension and web client with additional features for Pi MusicBox";
    homepage = "https://github.com/pimusicbox/mopidy-musicbox-webclient";
    changelog = "https://github.com/pimusicbox/mopidy-musicbox-webclient/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
