{ lib, stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-musicbox-webclient";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    rev = "v${version}";
    sha256 = "1lzarazq67gciyn6r8cdms0f7j0ayyfwhpf28z93ydb280mfrrb9";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    broken = stdenv.isDarwin;
    maintainers = [ maintainers.spwhitt ];
  };
}
