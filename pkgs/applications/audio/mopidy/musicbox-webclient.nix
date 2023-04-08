{ lib
, fetchFromGitHub
, pythonPackages
, mopidy
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-musicbox-webclient";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lzarazq67gciyn6r8cdms0f7j0ayyfwhpf28z93ydb280mfrrb9";
  };

  propagatedBuildInputs = [
    mopidy
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Mopidy frontend extension and web client with additional features for Pi MusicBox";
    homepage = "https://github.com/pimusicbox/mopidy-musicbox-webclient";
    changelog = "https://github.com/pimusicbox/mopidy-musicbox-webclient/blob/v${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ spwhitt ];
  };
}
